## 박스오피스 프로젝트 

### 프로젝트 목표

- Clean Architecture + MVVM 학습 및 적용
- HTTP 통신을 처리할 수 있는 네트워크 모듈 생성
- Swift Concurrency 학습 및 적용

### 프로젝트 구조

**Clean Architecture + MVVM**

- `Presentaion`: View, ViewModel
- `Domain`: Entity, Use Case, Repository Interface
- `Data`: Repository
- 의존성의 방향이 안쪽 방향으로만(`Domain`) 향하게 하고 안쪽에서 바깥 방향으로는 의존하지 않는 구조

### 스크린샷
- 일일 박스오피스 조회 / 영화 상세 화면


## 학습 내용

### Navigator + Depengency Manager

- VC간의 결합도를 줄이고 응집도를 높이기 위한 라우팅 객체(`Navigator`)와 의존성 주입을 위한 객체(`Depengency Manager`)

### 디자인패턴 적용 - 옵저버 패턴

- `Observable`을 활용한 옵저버 패턴 적용(`ViewController` ↔ `ViewModel`)
- 데이터 바인딩을 통한 반응형 프로그래밍 구현

### 네트워크 모듈

- 다양한 형태의 `Request`와 `Response`를 처리할 수 있는 네트워크 모듈
- 하나의 모듈로 다양한 API 가능

### Cache

- 네트워크 통신을 통해 불러온 이미지 캐싱
- `NSCache`

## Migration

- ViewModel → ViewModel with InputOutput Pattern - 양방향 바인딩
- 비동기 처리 마이그레이션(`Completion Handler` → `Swift Concurrency`)
