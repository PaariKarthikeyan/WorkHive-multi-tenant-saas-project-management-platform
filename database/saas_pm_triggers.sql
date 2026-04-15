-- ============================================================
-- WorkHive — DB Triggers & Stored Procedures
-- File: database/saas_pm_triggers.sql
-- Import AFTER all other SQL files have been imported.
-- ============================================================

DROP TRIGGER IF EXISTS trg_after_project_insert;
DROP TRIGGER IF EXISTS trg_after_project_delete;
DROP TRIGGER IF EXISTS trg_after_task_insert;
DROP TRIGGER IF EXISTS trg_after_task_update;
DROP TRIGGER IF EXISTS trg_after_task_delete;

DROP PROCEDURE IF EXISTS sp_create_project;
DROP PROCEDURE IF EXISTS sp_create_task;

DELIMITER $$

-- ============================================================
-- TRIGGER 1: After a project is inserted
-- ============================================================
CREATE TRIGGER trg_after_project_insert
AFTER INSERT ON projects
FOR EACH ROW
BEGIN
  INSERT INTO analytics_summary (
    tenant_id, total_projects, active_projects,
    total_tasks, completed_tasks, pending_tasks, inprogress_tasks,
    total_teams, total_employees
  )
  VALUES (
    NEW.tenant_id, 1, IF(NEW.status = 'active', 1, 0),
    0, 0, 0, 0, 0, 0
  )
  ON DUPLICATE KEY UPDATE
    total_projects  = total_projects  + 1,
    active_projects = active_projects + IF(NEW.status = 'active', 1, 0);

  INSERT INTO activity_logs (tenant_id, action, entity_type, entity_id, actor_id)
  VALUES (NEW.tenant_id, 'CREATE', 'project', NEW.project_id, NEW.tenant_id);
END$$

-- ============================================================
-- TRIGGER 2: After a project is deleted
-- ============================================================
CREATE TRIGGER trg_after_project_delete
AFTER DELETE ON projects
FOR EACH ROW
BEGIN
  UPDATE analytics_summary
  SET
    total_projects  = GREATEST(total_projects  - 1, 0),
    active_projects = GREATEST(active_projects - IF(OLD.status = 'active', 1, 0), 0)
  WHERE tenant_id = OLD.tenant_id;
END$$

-- ============================================================
-- TRIGGER 3: After a task is inserted
-- ============================================================
CREATE TRIGGER trg_after_task_insert
AFTER INSERT ON tasks
FOR EACH ROW
BEGIN
  DECLARE v_tenant_id INT;
  SELECT tenant_id INTO v_tenant_id FROM projects WHERE project_id = NEW.project_id;

  INSERT INTO analytics_summary (
    tenant_id, total_projects, active_projects,
    total_tasks, completed_tasks, pending_tasks, inprogress_tasks,
    total_teams, total_employees
  )
  VALUES (
    v_tenant_id, 0, 0, 1,
    IF(NEW.status = 'completed',   1, 0),
    IF(NEW.status = 'pending',     1, 0),
    IF(NEW.status = 'in_progress', 1, 0),
    0, 0
  )
  ON DUPLICATE KEY UPDATE
    total_tasks      = total_tasks      + 1,
    completed_tasks  = completed_tasks  + IF(NEW.status = 'completed',   1, 0),
    pending_tasks    = pending_tasks    + IF(NEW.status = 'pending',     1, 0),
    inprogress_tasks = inprogress_tasks + IF(NEW.status = 'in_progress', 1, 0);

  INSERT INTO activity_logs (tenant_id, action, entity_type, entity_id, actor_id)
  VALUES (v_tenant_id, 'CREATE', 'task', NEW.task_id, NEW.assigned_by);
END$$

-- ============================================================
-- TRIGGER 4: After a task status changes
-- ============================================================
CREATE TRIGGER trg_after_task_update
AFTER UPDATE ON tasks
FOR EACH ROW
BEGIN
  DECLARE v_tenant_id INT;

  IF OLD.status != NEW.status THEN
    SELECT tenant_id INTO v_tenant_id FROM projects WHERE project_id = NEW.project_id;

    UPDATE analytics_summary
    SET
      completed_tasks  = completed_tasks
        + IF(NEW.status = 'completed',   1, 0)
        - IF(OLD.status = 'completed',   1, 0),
      pending_tasks    = pending_tasks
        + IF(NEW.status = 'pending',     1, 0)
        - IF(OLD.status = 'pending',     1, 0),
      inprogress_tasks = inprogress_tasks
        + IF(NEW.status = 'in_progress', 1, 0)
        - IF(OLD.status = 'in_progress', 1, 0)
    WHERE tenant_id = v_tenant_id;

    IF NEW.status = 'completed' THEN
      INSERT INTO activity_logs (tenant_id, action, entity_type, entity_id, actor_id)
      VALUES (v_tenant_id, 'COMPLETE', 'task', NEW.task_id, NEW.assigned_to);
    END IF;
  END IF;
END$$

-- ============================================================
-- TRIGGER 5: After a task is deleted
-- ============================================================
CREATE TRIGGER trg_after_task_delete
AFTER DELETE ON tasks
FOR EACH ROW
BEGIN
  DECLARE v_tenant_id INT;
  SELECT tenant_id INTO v_tenant_id FROM projects WHERE project_id = OLD.project_id;

  UPDATE analytics_summary
  SET
    total_tasks      = GREATEST(total_tasks      - 1, 0),
    completed_tasks  = GREATEST(completed_tasks  - IF(OLD.status = 'completed',   1, 0), 0),
    pending_tasks    = GREATEST(pending_tasks    - IF(OLD.status = 'pending',     1, 0), 0),
    inprogress_tasks = GREATEST(inprogress_tasks - IF(OLD.status = 'in_progress', 1, 0), 0)
  WHERE tenant_id = v_tenant_id;
END$$

-- ============================================================
-- STORED PROCEDURE 1: sp_create_project
-- Uses a labeled block so LEAVE works correctly in MySQL.
-- ============================================================
CREATE PROCEDURE sp_create_project(
  IN  p_tenant_id      INT,
  IN  p_name           VARCHAR(150),
  IN  p_description    TEXT,
  IN  p_type           VARCHAR(80),
  IN  p_priority       VARCHAR(20),
  IN  p_est_end_date   DATE,
  IN  p_team_id        INT,
  IN  p_created_by     INT,
  IN  p_max_projects   INT,
  OUT p_project_id     INT,
  OUT p_error          VARCHAR(255)
)
BEGIN
  DECLARE v_count       INT DEFAULT 0;
  DECLARE v_existing_id INT DEFAULT 0;
  DECLARE v_manager_id  INT DEFAULT NULL;
  DECLARE v_team_name   VARCHAR(150) DEFAULT '';

  SET p_project_id = 0;
  SET p_error = '';

  main_block: BEGIN

    -- 1. Plan limit check
    IF p_max_projects != -1 THEN
      SELECT COUNT(*) INTO v_count
      FROM projects WHERE tenant_id = p_tenant_id;

      IF v_count >= p_max_projects THEN
        SET p_error = CONCAT('Plan limit reached: max ', p_max_projects, ' projects allowed.');
        LEAVE main_block;
      END IF;
    END IF;

    -- 2. Team conflict check
    IF p_team_id IS NOT NULL THEN
      SELECT project_id INTO v_existing_id
      FROM projects
      WHERE team_id = p_team_id
        AND tenant_id = p_tenant_id
        AND status NOT IN ('completed','cancelled')
      LIMIT 1;

      IF v_existing_id > 0 THEN
        SET p_error = 'This team is already assigned to another active project.';
        LEAVE main_block;
      END IF;
    END IF;

    -- 3. Insert project (triggers fire here automatically)
    INSERT INTO projects (tenant_id, name, description, type, priority, est_end_date, team_id)
    VALUES (p_tenant_id, p_name, p_description, p_type, p_priority, p_est_end_date, p_team_id);

    SET p_project_id = LAST_INSERT_ID();

    -- 4. Notify manager
    IF p_team_id IS NOT NULL THEN
      SELECT manager_id, team_name INTO v_manager_id, v_team_name
      FROM teams WHERE team_id = p_team_id LIMIT 1;

      IF v_manager_id IS NOT NULL THEN
        INSERT INTO notifications (user_id, type, title, message, data)
        VALUES (
          v_manager_id,
          'new_project',
          'New Project Assigned',
          CONCAT('Your team "', v_team_name, '" has been assigned to a new project: "', p_name, '".'),
          JSON_OBJECT('project_id', p_project_id)
        );
      END IF;
    END IF;

  END main_block;
END$$

-- ============================================================
-- STORED PROCEDURE 2: sp_create_task
-- ============================================================
CREATE PROCEDURE sp_create_task(
  IN  p_project_id    INT,
  IN  p_assigned_by   INT,
  IN  p_assigned_to   INT,
  IN  p_name          VARCHAR(200),
  IN  p_description   TEXT,
  IN  p_priority      VARCHAR(20),
  IN  p_deadline      DATE,
  OUT p_task_id       INT,
  OUT p_error         VARCHAR(255)
)
BEGIN
  DECLARE v_tenant_id   INT DEFAULT NULL;
  DECLARE v_user_exists INT DEFAULT 0;

  SET p_task_id = 0;
  SET p_error = '';

  main_block: BEGIN

    -- 1. Verify project exists and get tenant
    SELECT tenant_id INTO v_tenant_id
    FROM projects WHERE project_id = p_project_id LIMIT 1;

    IF v_tenant_id IS NULL THEN
      SET p_error = 'Project not found.';
      LEAVE main_block;
    END IF;

    -- 2. Validate assignee belongs to same tenant
    IF p_assigned_to IS NOT NULL THEN
      SELECT COUNT(*) INTO v_user_exists
      FROM users WHERE user_id = p_assigned_to AND tenant_id = v_tenant_id;

      IF v_user_exists = 0 THEN
        SET p_error = 'Assigned user does not belong to this tenant.';
        LEAVE main_block;
      END IF;
    END IF;

    -- 3. Insert task (trg_after_task_insert fires automatically)
    INSERT INTO tasks (project_id, assigned_by, assigned_to, name, description, priority, deadline, status, completion_pct)
    VALUES (p_project_id, p_assigned_by, p_assigned_to, p_name, p_description, p_priority, p_deadline, 'pending', 0);

    SET p_task_id = LAST_INSERT_ID();

    -- 4. Notify assignee
    IF p_assigned_to IS NOT NULL THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        p_assigned_to,
        'task_assigned',
        'New Task Assigned',
        CONCAT('You have been assigned: "', p_name, '".'),
        JSON_OBJECT('task_id', p_task_id, 'project_id', p_project_id)
      );
    END IF;

  END main_block;
END$$

DELIMITER ;
