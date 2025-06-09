from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import time
from datetime import datetime
from .config import settings

app = FastAPI(
    title=settings.APP_NAME,
    description="FastAPI 백엔드 서비스 - 데이터 관리 API",
    version=settings.APP_VERSION,
    debug=settings.DEBUG
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

# 데이터 모델


class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    price: float
    category: str
    created_at: Optional[datetime] = None


class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    category: str


# 임시 데이터 저장소 (실제로는 데이터베이스 사용)
items_db = [
    {
        "id": 1,
        "name": "노트북",
        "description": "고성능 개발용 노트북",
        "price": 1500000.0,
        "category": "전자제품",
        "created_at": datetime.now()
    },
    {
        "id": 2,
        "name": "마우스",
        "description": "무선 게이밍 마우스",
        "price": 80000.0,
        "category": "전자제품",
        "created_at": datetime.now()
    }
]


@app.get("/")
async def root():
    return {
        "message": "FastAPI 백엔드 서비스",
        "service": "backend-fastapi",
        "version": "1.0.0",
        "timestamp": time.time()
    }


@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "FastAPI Backend Service",
        "timestamp": time.time()
    }


@app.get("/api/items", response_model=List[Item])
async def get_items():
    """모든 아이템 조회"""
    return items_db


@app.get("/api/items/{item_id}", response_model=Item)
async def get_item(item_id: int):
    """특정 아이템 조회"""
    item = next((item for item in items_db if item["id"] == item_id), None)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item


@app.post("/api/items", response_model=Item)
async def create_item(item: ItemCreate):
    """새 아이템 생성"""
    new_id = max([item["id"] for item in items_db], default=0) + 1
    new_item = {
        "id": new_id,
        "name": item.name,
        "description": item.description,
        "price": item.price,
        "category": item.category,
        "created_at": datetime.now()
    }
    items_db.append(new_item)
    return new_item


@app.put("/api/items/{item_id}", response_model=Item)
async def update_item(item_id: int, item: ItemCreate):
    """아이템 수정"""
    existing_item = next(
        (item for item in items_db if item["id"] == item_id), None)
    if not existing_item:
        raise HTTPException(status_code=404, detail="Item not found")

    existing_item.update({
        "name": item.name,
        "description": item.description,
        "price": item.price,
        "category": item.category
    })
    return existing_item


@app.delete("/api/items/{item_id}")
async def delete_item(item_id: int):
    """아이템 삭제"""
    global items_db
    items_db = [item for item in items_db if item["id"] != item_id]
    return {"message": "Item deleted successfully"}


@app.get("/api/categories")
async def get_categories():
    """카테고리 목록 조회"""
    categories = list(set(item["category"] for item in items_db))
    return {"categories": categories}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
