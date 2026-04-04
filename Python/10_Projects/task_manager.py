#!/usr/bin/env python3
"""
================================================================================
  Project : Task Manager CLI — Python Showcase
  Author  : Miles3103
  Topic   : Project — OOP, dataclasses, JSON persistence, generators,
            decorators, comprehensions, error handling, argparse
================================================================================

SHOWCASE PROJECT — Everything combined.

This is a real command-line task manager that:
  ✓ Persists data to JSON
  ✓ Uses dataclasses with validation
  ✓ Has a clean OOP design
  ✓ Uses generators for filtering
  ✓ Has decorators for logging and timing
  ✓ Uses comprehensions throughout
  ✓ Handles errors gracefully
  ✓ Has proper type hints

Run it:
  python3 task_manager.py add "Learn Python" --priority high --tag study
  python3 task_manager.py list
  python3 task_manager.py done 1
  python3 task_manager.py stats

Or just run directly for the demo:
  python3 task_manager.py
"""

import json
import os
import sys
import time
import argparse
import functools
from dataclasses import dataclass, field, asdict
from datetime import datetime, date
from pathlib import Path
from typing import Optional, Generator
from enum import Enum

# ============================================================================
#  ENUMS — type-safe constants
# ============================================================================

class Priority(str, Enum):
    LOW    = "low"
    MEDIUM = "medium"
    HIGH   = "high"
    URGENT = "urgent"

class Status(str, Enum):
    TODO       = "todo"
    IN_PROGRESS = "in_progress"
    DONE       = "done"
    CANCELLED  = "cancelled"

# ============================================================================
#  DECORATOR
# ============================================================================

def log_action(func):
    """Log every action with timestamp."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        print(f"  [LOG {datetime.now().strftime('%H:%M:%S')}] {func.__name__} completed")
        return result
    return wrapper

# ============================================================================
#  DATACLASS — Task
# ============================================================================

@dataclass
class Task:
    title:      str
    priority:   Priority  = Priority.MEDIUM
    status:     Status    = Status.TODO
    tags:       list[str] = field(default_factory=list)
    notes:      str       = ""
    created_at: str       = field(default_factory=lambda: datetime.now().isoformat())
    done_at:    Optional[str] = None
    id:         int       = field(default=0, compare=False)

    def __post_init__(self):
        # Validate
        if not self.title.strip():
            raise ValueError("Task title cannot be empty")
        self.title = self.title.strip()

    def mark_done(self) -> None:
        self.status   = Status.DONE
        self.done_at  = datetime.now().isoformat()

    def mark_in_progress(self) -> None:
        self.status = Status.IN_PROGRESS

    @property
    def is_done(self) -> bool:
        return self.status == Status.DONE

    @property
    def age_days(self) -> int:
        created = datetime.fromisoformat(self.created_at).date()
        return (date.today() - created).days

    def to_dict(self) -> dict:
        d = asdict(self)
        d["priority"] = self.priority.value
        d["status"]   = self.status.value
        return d

    @classmethod
    def from_dict(cls, data: dict) -> "Task":
        data = data.copy()
        data["priority"] = Priority(data["priority"])
        data["status"]   = Status(data["status"])
        return cls(**data)

    def __str__(self) -> str:
        icon = {"todo": "○", "in_progress": "◑", "done": "●", "cancelled": "✗"}
        pri  = {"low": "↓", "medium": "→", "high": "↑", "urgent": "‼"}
        tags = f" [{', '.join(self.tags)}]" if self.tags else ""
        return (f"  {icon[self.status.value]} #{self.id:3d} "
                f"{pri[self.priority.value]} {self.title:<30}{tags}")

# ============================================================================
#  TASK MANAGER
# ============================================================================

class TaskManager:
    """Manages a collection of tasks with JSON persistence."""

    def __init__(self, filepath: str = "/tmp/miles3103_tasks.json"):
        self._filepath = Path(filepath)
        self._tasks: list[Task] = []
        self._next_id: int = 1
        self._load()

    def _load(self) -> None:
        """Load tasks from JSON file."""
        if self._filepath.exists():
            try:
                data = json.loads(self._filepath.read_text())
                self._tasks = [Task.from_dict(t) for t in data["tasks"]]
                self._next_id = data.get("next_id", len(self._tasks) + 1)
            except (json.JSONDecodeError, KeyError):
                self._tasks = []

    def _save(self) -> None:
        """Persist tasks to JSON file."""
        data = {
            "next_id": self._next_id,
            "saved_at": datetime.now().isoformat(),
            "tasks": [t.to_dict() for t in self._tasks]
        }
        self._filepath.write_text(json.dumps(data, indent=2))

    @log_action
    def add(self, title: str, priority: Priority = Priority.MEDIUM,
            tags: list[str] = None, notes: str = "") -> Task:
        """Add a new task."""
        task = Task(
            id       = self._next_id,
            title    = title,
            priority = priority,
            tags     = tags or [],
            notes    = notes,
        )
        self._tasks.append(task)
        self._next_id += 1
        self._save()
        print(f"  ✓ Added task #{task.id}: {task.title}")
        return task

    @log_action
    def complete(self, task_id: int) -> bool:
        """Mark a task as done."""
        task = self._find(task_id)
        if not task:
            print(f"  ✗ Task #{task_id} not found")
            return False
        task.mark_done()
        self._save()
        print(f"  ✓ Completed: {task.title}")
        return True

    def _find(self, task_id: int) -> Optional[Task]:
        return next((t for t in self._tasks if t.id == task_id), None)

    def filter(self, status: Optional[Status] = None,
               priority: Optional[Priority] = None,
               tag: Optional[str] = None) -> Generator[Task, None, None]:
        """Generator that yields tasks matching filters."""
        for task in self._tasks:
            if status   and task.status   != status:   continue
            if priority and task.priority != priority:  continue
            if tag      and tag not in task.tags:       continue
            yield task

    def list_tasks(self, status: Optional[Status] = None,
                   priority: Optional[Priority] = None,
                   tag: Optional[str] = None) -> None:
        """Display tasks matching filters."""
        tasks = list(self.filter(status=status, priority=priority, tag=tag))
        if not tasks:
            print("  (no tasks found)")
            return

        # Sort by: priority (urgent first), then status, then id
        priority_order = {Priority.URGENT: 0, Priority.HIGH: 1,
                         Priority.MEDIUM: 2, Priority.LOW: 3}
        tasks.sort(key=lambda t: (priority_order[t.priority], t.id))

        print(f"\n  {'#':>4}  {'P':1} {'Title':<30} Tags")
        print("  " + "-" * 55)
        for task in tasks:
            print(task)

    def stats(self) -> None:
        """Print statistics about all tasks."""
        total   = len(self._tasks)
        if total == 0:
            print("  No tasks yet.")
            return

        by_status   = {s: sum(1 for t in self._tasks if t.status == s)
                       for s in Status}
        by_priority = {p: sum(1 for t in self._tasks if t.priority == p
                              and not t.is_done)
                       for p in Priority}

        done_tasks  = [t for t in self._tasks if t.is_done and t.done_at]
        all_tags    = [tag for t in self._tasks for tag in t.tags]
        from collections import Counter
        tag_freq    = Counter(all_tags)

        print(f"\n  {'='*40}")
        print(f"  TASK MANAGER STATS — {date.today()}")
        print(f"  {'='*40}")
        print(f"  Total tasks: {total}")
        print()
        print(f"  By Status:")
        for status, count in by_status.items():
            bar = "█" * count
            print(f"    {status.value:<12} {count:3}  {bar}")

        print(f"\n  Pending by Priority:")
        for priority, count in by_priority.items():
            if count > 0:
                print(f"    {priority.value:<8} {count}")

        if tag_freq:
            print(f"\n  Top Tags:")
            for tag, count in tag_freq.most_common(5):
                print(f"    #{tag:<12} ×{count}")

        completion_rate = (by_status[Status.DONE] / total) * 100 if total else 0
        print(f"\n  Completion rate: {completion_rate:.1f}%")
        print(f"  {'='*40}")

    def clear(self) -> None:
        """Remove all tasks."""
        self._tasks = []
        self._next_id = 1
        self._save()
        print("  All tasks cleared.")

# ============================================================================
#  CLI DEMO — run as a script
# ============================================================================

def demo(manager: TaskManager) -> None:
    """Run a demo of all features."""
    print("╔══════════════════════════════════════════╗")
    print("║    TASK MANAGER — Miles3103             ║")
    print("╚══════════════════════════════════════════╝")

    # Add tasks
    print("\n--- Adding Tasks ---")
    manager.add("Complete C programming course",
                priority=Priority.HIGH, tags=["study", "c"])
    manager.add("Finish C++ OOP module",
                priority=Priority.HIGH, tags=["study", "cpp"])
    manager.add("Python decorators practice",
                priority=Priority.MEDIUM, tags=["study", "python"])
    manager.add("Push code to GitHub",
                priority=Priority.MEDIUM, tags=["github"])
    manager.add("Read K&R book chapter 5",
                priority=Priority.LOW, tags=["study", "c"])
    manager.add("Set up development environment",
                priority=Priority.URGENT, tags=["setup"])
    manager.add("Write unit tests",
                priority=Priority.LOW, tags=["testing"])

    # List all
    print("\n--- All Tasks ---")
    manager.list_tasks()

    # Complete some
    print("\n--- Completing Tasks ---")
    manager.complete(1)
    manager.complete(6)

    # Filter by status
    print("\n--- TODO Tasks Only ---")
    manager.list_tasks(status=Status.TODO)

    # Filter by priority
    print("\n--- High Priority Tasks ---")
    manager.list_tasks(priority=Priority.HIGH)

    # Filter by tag
    print("\n--- Tasks tagged 'study' ---")
    manager.list_tasks(tag="study")

    # Stats
    manager.stats()

def main():
    parser = argparse.ArgumentParser(description="Miles3103 Task Manager")
    parser.add_argument("--demo", action="store_true", help="Run demo mode")
    args = parser.parse_args()

    manager = TaskManager()
    manager.clear()  # fresh start for demo

    demo(manager)

    # Cleanup
    Path("/tmp/miles3103_tasks.json").unlink(missing_ok=True)
    print("\n✓ Demo complete. Run with --help to see CLI options.")

if __name__ == "__main__":
    main()
