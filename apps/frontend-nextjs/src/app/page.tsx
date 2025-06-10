'use client';

import { useState, useEffect } from 'react';
import { getApiUrl, apiRequest } from '../lib/api';

interface ServiceStatus {
  name: string;
  url: string;
  status: 'healthy' | 'error' | 'loading';
  response?: string;
  error?: string;
}

interface Item {
  id: number;
  name: string;
  description: string;
  price: number;
  category: string;
}

export default function Dashboard() {
  const [services, setServices] = useState<ServiceStatus[]>([
    { name: 'Next.js 프론트엔드', url: '/', status: 'loading' },
    { name: 'Spring Boot 백엔드', url: 'http://localhost:8080/api/auth/health', status: 'loading' },
    { name: 'FastAPI 백엔드', url: 'http://localhost:8000/health', status: 'loading' },
  ]);

  const [authTest, setAuthTest] = useState<Record<string, unknown> | null>(null);
  const [items, setItems] = useState<Item[]>([]);
  const [newItem, setNewItem] = useState({ name: '', description: '', price: 0, category: '' });

  // 서비스 상태 확인
  useEffect(() => {
    const checkServices = async () => {
      const { springBootUrl, fastApiUrl } = getApiUrl();
      
      const serviceUrls = [
        { name: 'Next.js 프론트엔드', url: '/', status: 'loading' as const },
        { name: 'Spring Boot 백엔드', url: `${springBootUrl}/api/auth/health`, status: 'loading' as const },
        { name: 'FastAPI 백엔드', url: `${fastApiUrl}/health`, status: 'loading' as const },
      ];

      const updatedServices = await Promise.all(
        serviceUrls.map(async (service) => {
          if (service.name === 'Next.js 프론트엔드') {
            return { ...service, status: 'healthy' as const, response: JSON.stringify({ message: '정상 작동 중' }) };
          }

          try {
            const response = await fetch(service.url);
            const data = await response.json();
            return { ...service, status: 'healthy' as const, response: JSON.stringify(data) };
          } catch (error) {
            return { 
              ...service, 
              status: 'error' as const, 
              error: error instanceof Error ? error.message : '알 수 없는 오류' 
            };
          }
        })
      );
      setServices(updatedServices);
    };

    checkServices();
    
    // 30초마다 상태 확인
    const interval = setInterval(checkServices, 30000);
    return () => clearInterval(interval);
  }, []); // 빈 의존성 배열로 변경

  // 아이템 목록 조회
  useEffect(() => {
    const fetchItems = async () => {
      try {
        const response = await fetch('http://localhost:8000/api/items');
        const data = await response.json();
        setItems(data);
      } catch (error) {
        console.error('아이템 조회 실패:', error);
      }
    };

    fetchItems();
  }, []);

  // 인증 테스트
  const testAuth = async () => {
    try {
      const response = await apiRequest('/api/auth/login', {
        method: 'POST',
        body: JSON.stringify({ username: 'admin', password: 'password' }),
      });
      const data = await response.json();
      setAuthTest(data);
    } catch (error) {
      setAuthTest({ error: error instanceof Error ? error.message : '인증 실패' });
    }
  };

  // 새 아이템 추가
  const addItem = async () => {
    if (!newItem.name || !newItem.category || newItem.price <= 0) {
      alert('모든 필드를 올바르게 입력해주세요.');
      return;
    }

    try {
      const response = await fetch('http://localhost:8000/api/items', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newItem),
      });
      const data = await response.json();
      setItems([...items, data]);
      setNewItem({ name: '', description: '', price: 0, category: '' });
    } catch (error) {
      console.error('아이템 추가 실패:', error);
    }
  };

  // 아이템 삭제
  const deleteItem = async (id: number) => {
    try {
      await fetch(`http://localhost:8000/api/items/${id}`, { method: 'DELETE' });
      setItems(items.filter(item => item.id !== id));
    } catch (error) {
      console.error('아이템 삭제 실패:', error);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* 헤더 */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            🚀 모노레포 대시보드
          </h1>
          <p className="text-xl text-gray-600">
            Next.js + Spring Boot + FastAPI 통합 개발 환경
          </p>
        </div>

        {/* 서비스 상태 */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">🔍 서비스 상태</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {services.map((service, index) => (
              <div key={index} className="bg-white rounded-lg shadow-md p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-gray-900">{service.name}</h3>
                  <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                    service.status === 'healthy' 
                      ? 'bg-green-100 text-green-800' 
                      : service.status === 'error'
                      ? 'bg-red-100 text-red-800'
                      : 'bg-yellow-100 text-yellow-800'
                  }`}>
                    {service.status === 'healthy' ? '정상' : service.status === 'error' ? '오류' : '확인 중'}
                  </span>
                </div>
                {service.response && (
                  <pre className="text-sm text-gray-600 bg-gray-50 p-3 rounded overflow-x-auto">
                    {service.response}
                  </pre>
                )}
                {service.error && (
                  <p className="text-sm text-red-600 bg-red-50 p-3 rounded">{service.error}</p>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* 인증 테스트 */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">🔐 Spring Boot 인증 테스트</h2>
          <div className="bg-white rounded-lg shadow-md p-6">
            <button
              onClick={testAuth}
              className="bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg transition-colors"
            >
              로그인 테스트 (admin/password)
            </button>
            {authTest && (
              <div className="mt-4">
                <pre className="text-sm text-gray-600 bg-gray-50 p-4 rounded overflow-x-auto">
                  {JSON.stringify(authTest, null, 2)}
                </pre>
              </div>
            )}
          </div>
        </div>

        {/* FastAPI 아이템 관리 */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">📦 FastAPI 아이템 관리</h2>
          
          {/* 새 아이템 추가 */}
          <div className="bg-white rounded-lg shadow-md p-6 mb-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">새 아이템 추가</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
              <input
                type="text"
                placeholder="아이템 이름"
                value={newItem.name}
                onChange={(e) => setNewItem({ ...newItem, name: e.target.value })}
                className="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <input
                type="text"
                placeholder="설명"
                value={newItem.description}
                onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}
                className="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <input
                type="number"
                placeholder="가격"
                value={newItem.price || ''}
                onChange={(e) => setNewItem({ ...newItem, price: Number(e.target.value) })}
                className="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <input
                type="text"
                placeholder="카테고리"
                value={newItem.category}
                onChange={(e) => setNewItem({ ...newItem, category: e.target.value })}
                className="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                onClick={addItem}
                className="bg-green-500 hover:bg-green-600 text-white font-medium py-2 px-4 rounded-lg transition-colors"
              >
                추가
              </button>
            </div>
          </div>

          {/* 아이템 목록 */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">아이템 목록</h3>
            </div>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">이름</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">설명</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">가격</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">카테고리</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">작업</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {items.map((item) => (
                    <tr key={item.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{item.id}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{item.name}</td>
                      <td className="px-6 py-4 text-sm text-gray-500">{item.description}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">₩{item.price.toLocaleString()}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{item.category}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button
                          onClick={() => deleteItem(item.id)}
                          className="text-red-600 hover:text-red-900 transition-colors"
                        >
                          삭제
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* 기술 스택 정보 */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">🛠️ 기술 스택</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-4xl mb-2">⚛️</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Frontend</h3>
              <p className="text-gray-600">Next.js 15, React 19, TypeScript, Tailwind CSS</p>
            </div>
            <div className="text-center">
              <div className="text-4xl mb-2">🌱</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Backend (Auth)</h3>
              <p className="text-gray-600">Spring Boot 3.2, Java 17, PostgreSQL, JWT</p>
            </div>
            <div className="text-center">
              <div className="text-4xl mb-2">🐍</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Backend (API)</h3>
              <p className="text-gray-600">FastAPI, Python 3.11, SQLAlchemy, Pydantic</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
