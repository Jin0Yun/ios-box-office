## 박스오피스 프로젝트
> 일별 박스오피스 정보 및 영화 상세정보를 확인할 수 있는 앱
> 
> 프로젝트기간: 2024.02.13 ~ 2024.03.15 (6주간)

## 목차
1. [프로젝트 목표](#프로젝트-목표)
2. [개발환경 및 활용한 기술](#개발환경-및-활용한-기술)
3. [프로젝트 구조](#프로젝트-구조)
4. [스크린샷](#스크린샷)
5. [학습 내용](#학습-내용)
6. [PR Point](#pr-point)
7. [Trouble Shooting](#trouble-shooting)
8. [팀원소개](#팀원소개)


## 프로젝트 목표

- Clean Architecture + MVVM 학습 및 적용
- HTTP 통신을 처리할 수 있는 네트워크 모듈 생성
- Swift Concurrency 학습 및 적용


### 개발환경 및 활용한 기술
| 개발언어 및 환경 | 협업도구 | 기술스택 | 
| --- | --- |--- |
| Swift | Notion | SwiftLint |
| UIKit | Github  | MVVM |
| Xcode 17.0 | Discord | Input-Output |
|   |   | Navigator |
|   |   | Observable |
|   |   | Completion Handler → Swift Concurrency |
|   |   | TDD |
  
### 프로젝트 구조

**Clean Architecture + MVVM**

- `Presentaion`: View, ViewModel
- `Domain`: Entity, Use Case, Repository Interface
- `Data`: Repository
- 의존성의 방향이 안쪽 방향으로만(`Domain`) 향하게 하고 안쪽에서 바깥 방향으로는 의존하지 않는 구조
<img width="1485" alt="스크린샷 2024-05-14 오후 8 11 23" src="https://github.com/Jin0Yun/ios-box-office/assets/47639904/1fa06226-e18e-46d6-a56e-40f2d056596f">

### 스크린샷
<table>
  <table>
  <tr>
    <tr>
    <th><code>박스오피스 CollectionView</code></th>
    <th><code>RefreshController</code></th>
    <th><code>기능설명</code></th>
  </tr>
    <td>
      <img src="https://github.com/tasty-code/ios-box-office/assets/133867430/d7014c97-50bd-4a80-8f8c-6a3dd18e2107" width="250" height="500" >
    </td>
    <td>
      <img src="https://github.com/tasty-code/ios-box-office/assets/133867430/aa3b37e8-8236-4439-94d5-80654028fcbe" width="250" height="500">
    </td>
    <td>
      <strong>일별 박스오피스</strong><br>
      CollectionView로 일별 박스오피스 리스트로 구현했습니다.<br><br>
      <strong>RefreshController</strong><br>
      로드 중임을 알 수 있게 하기위해 당겨서 새로고침을 구현했습니다.<br><br>
    </td>
  </tr>
  <tr>
    <tr>
    <th><code>Image Cache 전</code></th>
    <th><code>Image Cache 후</code></th>
    <th><code>기능설명</code></th>
  </tr>
    <td>
      <img src="https://github.com/tasty-code/ios-box-office/assets/133867430/200c611e-cc33-481c-a948-cf50db41a1b9" width="250" height="500" >
    </td>
    <td>
      <img src="https://github.com/tasty-code/ios-box-office/assets/133867430/608262f2-c0a4-4b91-b42d-b38283026b1d" width="250" height="500">
    </td>
     <td>
      <strong>영화 상세화면</strong><br>
      CollectionView로 영화 상세정보를 구현했습니다.<br><br>
      <strong>Indicator</strong><br>
      이미지가 로득되기 전에 이미지가 로드중임을 알 수 있도록 indicator를 구현했습니다.<br><br>
      <strong>Image caching</strong><br>
      한 번 로드된 이미지는 캐시를 통해 빠르게 로드될 수 있도록 구현했습니다.<br><br>
    </td>
  </tr>
</table>
  


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

### CollectionView
- CollectionView를 활용한 영화 목록 및 상세 정보 UI 구현
- `UIActivityIndicatorView` 및 `UIRefreshControl`를 활용해 로드 중 및 새로고침 UI 구현

### Migration

- ViewModel → ViewModel with InputOutput Pattern - 양방향 바인딩
- 비동기 처리 마이그레이션(`Completion Handler` → `Swift Concurrency`)

## PR Point 

- [STEP1](https://github.com/tasty-code/ios-box-office/pull/31)
- [STEP2](https://github.com/tasty-code/ios-box-office/pull/38)
- [STEP3](https://github.com/tasty-code/ios-box-office/pull/48)

## 팀원소개

| 윤진영([yuni](https://github.com/Jin0Yun)) | 장우석([sidi](https://github.com/jus1234)) |
| --- | --- |
| <img src = "https://github.com/tasty-code/ios-box-office/assets/133867430/efcdf5c8-efb8-42ce-8992-0ff16ce266a2" width="200" height="240"> | <img src = "https://github.com/tasty-code/ios-box-office/assets/133867430/fd03b3e7-bbd2-411f-b8fb-dd9970cc9dfb." width="200" height="240"> |

