# Ridi Paper Pro 리파티션 도구 r2 / r13
-------------------

# 용어 정리
- 파티션: 저장 공간을 통으로 쓸 순 없고 나누어들 쓰실텐데, 이 때 나눈 공간 하나하나를 파티션이라고 함. 또는 파티션 나누는 행위도 파티션이라고 함. (영어 단어니까 뭐...)
- 리파티션: 리(re) 붙었으니, 파티션 나누기를 다시 하겠다는 것.


# 준비물
- 리디 페이퍼 프로 기기
- 중요한 데이터 백업 정신
- 50% 이상 배터리 충전
- (권장) 데이터 자동 백업·복원 위한 SD 카드 + 8GB 이상 여유 공간 확보

- 루팅할 때 썼던 루트 도구 (버전 r12 이상)

- 지금 보고 계신 꾸러미
루트 도구 폴더에 압축 해제해 둘 것


# 리파티션 선택 및 이용할 파일
- 앱 공간 1G로 늘리기 (이하 1G)
리파티션 스크립트만 이용
update/repart_mod_1G.zip

- 앱 공간 + 사용자 공간 통합하기 (이하 통합)
리파티션 스크립트 + 루팅 패키지 모두 필요
update 폴더의
repart_mod_full.zip 파일 및
update_mod_r13_light.zip 또는 update_mod_r13_full.zip 파일 준비
(light: 루트 + 소프트키·앱서랍, full: 루트 + 모든 기본 앱)
cf) 루팅 패키지 이름 뒤에 '_w_recv_emusd'라고 붙여놨으나 생략했음. 찰떡같이 알아주시길.

또한, 통합 공간 지원하도록 별도로 마련한 리커버리 이미지 이용할 것임
images/recovery_r13_emusd_postota.img


# 절차
1. 중요한 데이터 백업


2. (SD카드 있으면) SD카드에 위 파일 준비물 넣어두기

없으면 이따가 넣을 것임


3. 적절한 리커버리로 재부팅
* 루팅할 때처럼 Fastboot 모드로 진입
cf) PC 연결 후 명령창에서 다음 명령 치면 손쉽게 진입 가능
> adb reboot fastboot
가끔 반응 없는 경우 있으나, 한 최대 30초 정도 기다리면 재부팅되고 진입 가능

* 선택한 방식에 따라 다른 이미지 이용
- 1G
fastboot boot images\recovery_adb_r13.img

- 통합
fastboot boot images\recovery_adb_r13_emusd.img

* TWRP 로고가 뜨고 나서 메인 메뉴가 뜰 때까지 잠시 기다리기
cf) 메인 메뉴 = [Install], [Wipe], .. 등등 버튼 보이고, 아래에 소프트키 보이는 화면


4. (SD카드 없으면) 준비물 넣을 시간
먼저 데이터 날려도 괜찮다는 의미로, 다음 명령 실행

adb shell touch /sdcard/.backup_tmpfs

그리고 다음 명령으로 파일 넣기
- 1G
adb push update/repart_mod_1G.zip /tmp

- 통합
adb push update/repart_mod_full.zip /tmp

cf) 루팅 패키지는 용량 문제로 이따가 넣을 것임


5. 리파티션 스크립트 실행

[Install] 누르고,

- (SD카드 있으면) SD 카드로 이동
화면 하단의 [Select Storage] 버튼 터치, 나타난 대화상자에서 [External SD Card], [OK] 차례로 터치

- (SD카드 없으면) 루트 폴더로 올라가 'tmp' 폴더로 이동
화면 가운데 목록에서 (Up a level) 터치해서 상위 폴더로 올라감
화면을 아래로 스크롤해서 'tmp' 찾아 터치
아까 4단계에서 넣은 파일 보이면 OK
cf) 스크롤 터치가 은근 어렵지만, 잘못 누르면 취소하거나, 상위 폴더로 돌아가면 그만!

이제 목록을 잘 스크롤해서 리파티션 스크립트 찾아 터치하면 설치 묻는 화면으로 이동

cf) 잘못 눌렀으면 화면 하단의 백 버튼 또는 [Clear Zip Queue] 버튼으로 취소

잘 골랐으면 [Swipe to install] 버튼 왼쪽에서 오른쪽으로 잘 밀면 설치 개시


6. 기다리기

화면 가운데에 이것저것 메시지가 지나감

#1. 백업, #2. 리파티션, #3. 포맷 및 복원 순서로 진행

백업, 복원이 각각 한..참 걸리니 참고해주시길..


7. 잘 되었나 보기

화면 위에 [Installation Finished]라 뜨고,

가운데 메시지에 뭐 수상한 메시지가 없으면 성공!

- 1G 고르셨으면 이걸로 끝, [Reboot] 선택해서 재부팅시키고 그냥 쓰시면 됨.

공식 "파티션 재조정"도 별 것 없는 것처럼.

- 그러나 통합 고르셨으면 여기서 끝이 아님, 다음 단계로 

cf) 바로 [Reboot] 하시면 여러모로 곤란해짐. 부팅은 잘 되겠지만 사용자 공간이 사라진 것처럼 나타날 것임.


8. (통합 선택 시) 한 번 더 루팅

- (SD 카드 없으면) 루팅 패키지 파일을 지금 넣어야 하는데,

그 전에 임시 공간을 한 번 비워주어야 함.

SD 카드가 없으니 시스템 파일을 쪼매만한 임시 공간에 백업했었고,

전체 500MB 가량인 임시 공간이 거의 차 있는 상황.

7단계에서 리파티션 잘 된 것 보았으니 자신있게 다음 명령으로 임시 파일 삭제.

> adb shell rm -r /tmp/backup_*

다음 아래 명령으로 루팅 패키지 기기에 넣기.

> adb push update/update_mod_r13_full_w_recv_emusd.zip /tmp/

cf) 올인원이 싫으시면 full 대신 light로 하셔도 됨.

- (SD 카드 있으면) 이미 2단계에서 넣어두었을 것임

이제 5단계와 같이 하되, 이번에는 루팅 패키지를 골라 설치 진행하시면 됨.

루팅하실 때 느끼셨듯이 루팅 패키지 설치는 순식간에 진행됨.


다 되었으면 [Reboot] 선택해서 재부팅시키고 그냥 쓰시면 됨.


끝!
