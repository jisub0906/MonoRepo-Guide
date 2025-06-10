// WSL 환경 감지 및 API URL 설정
export const getApiUrl = () => {
  // 브라우저 환경에서만 실행
  if (typeof window === 'undefined') {
    return {
      springBootUrl: 'http://localhost:8080',
      fastApiUrl: 'http://localhost:8000'
    };
  }

  // 현재 호스트 확인
  const currentHost = window.location.hostname;
  const currentPort = window.location.port;
  
  // WSL IP 패턴 감지 (일반적으로 172.x.x.x 또는 192.168.x.x)
  const isWSLIP = /^(172\.|192\.168\.)/.test(currentHost);
  
  if (isWSLIP || currentHost !== 'localhost') {
    // WSL IP로 접속한 경우, 같은 IP로 백엔드 접속
    return {
      springBootUrl: `http://${currentHost}:8080`,
      fastApiUrl: `http://${currentHost}:8000`
    };
  }
  
  // localhost인 경우 기본 설정
  return {
    springBootUrl: 'http://localhost:8080',
    fastApiUrl: 'http://localhost:8000'
  };
};

// API 요청 헬퍼 함수
export const apiRequest = async (endpoint: string, options: RequestInit = {}) => {
  const { springBootUrl, fastApiUrl } = getApiUrl();
  
  let baseUrl = '';
  if (endpoint.startsWith('/api/auth/') || endpoint.startsWith('/api/user/')) {
    baseUrl = springBootUrl;
  } else if (endpoint.startsWith('/api/items/') || endpoint.startsWith('/health')) {
    baseUrl = fastApiUrl;
  }
  
  const url = `${baseUrl}${endpoint}`;
  
  const defaultOptions: RequestInit = {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  };
  
  try {
    const response = await fetch(url, defaultOptions);
    return response;
  } catch (error) {
    console.error(`API 요청 실패: ${url}`, error);
    throw error;
  }
}; 