from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import date

app = FastAPI(title="Task Management API", description="API for managing tasks.")

# In-memory database for tasks
tasks_db = {}
next_task_id = 1

class TaskBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None
    due_date: Optional[date] = None

class TaskCreate(TaskBase):
    pass

class TaskUpdate(TaskBase):
    status: Optional[str] = None

class TaskInDB(TaskBase):
    id: int
    status: str = "pending"

    class Config:
        from_attributes = True

@app.get("/", summary="Root endpoint", tags=["General"])
async def read_root():
    return {"message": "Welcome to the Task Management API!"}

@app.get("/health", summary="Health check endpoint", tags=["General"])
async def health_check():
    return {"status": "ok", "message": "API is healthy"}

@app.get("/tasks", response_model=List[TaskInDB], summary="Retrieve all tasks", tags=["Tasks"])
async def get_all_tasks():
    return list(tasks_db.values())

@app.get("/tasks/{task_id}", response_model=TaskInDB, summary="Retrieve a single task by ID", tags=["Tasks"])
async def get_task(task_id: int):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    return tasks_db[task_id]

@app.post("/tasks", response_model=TaskInDB, status_code=201, summary="Create a new task", tags=["Tasks"])
async def create_task(task: TaskCreate):
    global next_task_id
    new_task = TaskInDB(id=next_task_id, **task.dict())
    tasks_db[next_task_id] = new_task
    next_task_id += 1
    return new_task

@app.put("/tasks/{task_id}", response_model=TaskInDB, summary="Update an existing task by ID", tags=["Tasks"])
async def update_task(task_id: int, task: TaskUpdate):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    
    current_task_data = tasks_db[task_id].dict()
    updated_task_data = task.dict(exclude_unset=True)
    for key, value in updated_task_data.items():
        current_task_data[key] = value
    
    tasks_db[task_id] = TaskInDB(**current_task_data)
    return tasks_db[task_id]

@app.delete("/tasks/{task_id}", status_code=204, summary="Delete a task by ID", tags=["Tasks"])
async def delete_task(task_id: int):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    del tasks_db[task_id]
    return

@app.get("/tasks/status/{status}", response_model=List[TaskInDB], summary="Retrieve tasks filtered by status", tags=["Tasks"])
async def get_tasks_by_status(status: str):
    filtered_tasks = [task for task in tasks_db.values() if task.status == status]
    return filtered_tasks

@app.get("/tasks/due_date/{due_date}", response_model=List[TaskInDB], summary="Retrieve tasks filtered by due date", tags=["Tasks"])
async def get_tasks_by_due_date(due_date: date):
    filtered_tasks = [task for task in tasks_db.values() if task.due_date == due_date]
    return filtered_tasks

@app.patch("/tasks/{task_id}/complete", response_model=TaskInDB, summary="Mark a task as completed", tags=["Tasks"])
async def complete_task(task_id: int):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    tasks_db[task_id].status = "completed"
    return tasks_db[task_id]

@app.patch("/tasks/{task_id}/pending", response_model=TaskInDB, summary="Mark a task as pending", tags=["Tasks"])
async def pending_task(task_id: int):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    tasks_db[task_id].status = "pending"
    return tasks_db[task_id]

@app.patch("/tasks/{task_id}/in_progress", response_model=TaskInDB, summary="Mark a task as in-progress", tags=["Tasks"])
async def in_progress_task(task_id: int):
    if task_id not in tasks_db:
        raise HTTPException(status_code=404, detail="Task not found")
    tasks_db[task_id].status = "in-progress"
    return tasks_db[task_id]

@app.get("/tasks/overdue", response_model=List[TaskInDB], summary="Retrieve all overdue tasks", tags=["Tasks"])
async def get_overdue_tasks():
    today = date.today()
    overdue_tasks = [task for task in tasks_db.values() if task.due_date and task.due_date < today and task.status != "completed"]
    return overdue_tasks

@app.get("/tasks/today", response_model=List[TaskInDB], summary="Retrieve tasks due today", tags=["Tasks"])
async def get_tasks_due_today():
    today = date.today()
    tasks_today = [task for task in tasks_db.values() if task.due_date == today and task.status != "completed"]
    return tasks_today

@app.get("/tasks/search", response_model=List[TaskInDB], summary="Search tasks by title or description", tags=["Tasks"])
async def search_tasks(
    query: str = Query(..., min_length=1, description="Search query for title or description")
):
    search_results = [
        task for task in tasks_db.values()
        if query.lower() in task.title.lower() or (task.description and query.lower() in task.description.lower())
    ]
    return search_results