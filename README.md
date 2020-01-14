# PaperProKitchen 리파티션 도구 (r2 | r13_2)

[![Release][release-target-badge]][release-target]

-----

## 배경 설명 및 용어 정리
- **파티션**: 사무실 나누어 쓰듯이 저장 공간도 나누어 씁니다. 이 때 나뉜 구획을 파티션이라고 하고, 나누는 일도 파티션(작업)한다고들 하는 것 같습니다.
- **리파티션**: 리(re) 붙여서, 파티션 나누기를 다시 하겠다고 말씀드리고자 썼습니다.

순정 기기는 전체 8G 공간 중 앱 저장 공간으로 512MB (=0.5GB), 이것저것 빼고 사용자 공간으로 나머지 용량을 할당하고 있습니다. 사용자 공간에 도서 많이 담아 보시라는 배려인 한편, 앱 설치하기에는 참으로 부족한 공간입니다.

지금 보고계신 도구는 사용자 공간을 희생하여, 앱 공간을 두 배, 즉 1G로 늘리거나, 아예 앱 공간과 사용자 공간을 통합하기 위한 절차를 안내합니다.

[자세한 가이드 (네이버 카페 이북리더스 *가입 필요)][detailed_guide]  

> ❌ 잘못되도 책임 안 집니다!

## 준비물
- 리디 페이퍼 프로 기기
- 중요한 데이터를 백업하는 정·신!
- 50% 이상 배터리 충전
- (권장) 8GB 이상 여유 공간이 있는 SD 카드를 기기에 장착 (*데이터 자동 백업·복원 위해*)
- 루팅할 때 썼던 루트 도구 (버전 r12 이상)
- 마지막으로 지금 보고 계신 리파티션 도구

먼저 리파티션 도구 압축 파일을 루트 도구 폴더에 압축 해제해 두세요.

## 리파티션 선택 및 이용할 파일

두 가지 베리에이션이 있습니다. 싫으시면 파티션 구성을 직접 결정 및 편집하셔야 하는데 방법은 번거로우니 적지 않겠습니다.

- 앱 공간 1G로 늘리기 (이하 1G)  
리파티션 스크립트만 이용  
`update/repart_mod_1G.zip`

- 앱 공간 + 사용자 공간 통합하기 (이하 통합)  
리파티션 스크립트 + (새로운) 루팅 패키지 모두 필요  
  * `update` 폴더
    * `repart_mod_full.zip` 파일
    * `update_mod_r13_light.zip` 또는 `update_mod_r13_full.zip` 파일  
    (light: 루트 + 소프트키·앱서랍, full: 루트 + 모든 기본 앱)  
    cf) 루팅 패키지 이름 뒤에 '_w_recv_emusd'라고 붙여놨으나 설명에서는 너무 길어지니 생략했습니다.
  * 또한, 통합 공간 지원하도록 별도로 마련한 리커버리 이미지를 이용하겠습니다:  
  `images/recovery_r13_emusd_postota.img`


##  작업 절차
1. 중요한 데이터 백업

2. (SD카드 **있으면**) SD카드에 위 파일 준비물 넣어두기  
> ❔ 없으면 리커버리로 부팅 후 필요할 때 넣겠습니다

3. 적절한 리커버리로 재부팅

* 루팅할 때 했던 것처럼 Fastboot 모드로 진입하세요
> 참고: PC 연결 후 명령창에서 다음 명령 치면 손쉽게 진입 가능합니다  
> `adb reboot fastboot`  
> 💡 가끔 반응 없는 경우 있으나, 한 최대 30초 정도 기다리면 재부팅되어 진입합니다.


* 이제 선택한 방식에 따라 적절한 리커버리 이미지를 골라 쓰세요.
  - 1G  
  `fastboot boot images\recovery_adb_r13.img`

  - 통합  
  `fastboot boot images\recovery_adb_r13_emusd.img`

* TWRP 로고가 뜨고 나서 메인 메뉴가 뜰 때까지 잠시 기다리세요  
cf) 메인 메뉴 = [Install], [Wipe], .. 등등 버튼 보이고, 아래에 소프트키 보이는 화면


4. (SD카드 **없으면**) 준비물 넣을 시간!
  먼저 데이터 날려도 괜찮다는 의미로, 다음 명령을 실행하세요

`adb shell touch /sdcard/.backup_tmpfs`

그리고 다음 명령으로 리파티션 스크립트 파일도 넣으세요.
- 1G
`adb push update/repart_mod_1G.zip /tmp`

- 통합
`adb push update/repart_mod_full.zip /tmp`  
cf) 루팅 패키지는 용량 문제가 있어 이따가 넣겠습니다.


5. 리파티션 스크립트 실행

먼저 [Install] 누르고,

- (SD카드 **있으면**) SD 카드로 이동
화면 하단의 [Select Storage] 버튼 터치, 나타난 대화상자에서 [External SD Card], [OK] 차례로 터치

- (SD카드 **없으면**) 루트 폴더로 올라가 'tmp' 폴더로 이동
  * 화면 가운데 목록에서 (Up a level) 터치해서 상위 폴더로 올라가세요  
  * 화면을 아래로 스크롤해서 'tmp' 찾아 터치  
  * 아까 4단계에서 넣은 파일 보이면 OK!  
  cf) 스크롤 터치가 은근 어렵지만, 잘못 누르면 취소하거나, 상위 폴더로 돌아가면 그만!입니다.

이제 목록을 잘 스크롤해서 리파티션 스크립트 찾아 터치하면 설치 여부 묻는 화면으로 이동합니다.  
cf) 잘못 눌렀으면 화면 하단의 **백 버튼** 또는 [Clear Zip Queue] 버튼으로 선택을 취소하세요

잘 골랐다면 [Swipe to install] 버튼 왼쪽에서 오른쪽으로 잘 밀면 설치, 아니 리파티션 개시!


6. 기다리기

화면 가운데에 이것저것 메시지가 지나갑니다.

#1. 백업, #2. 리파티션, #3. 포맷 및 복원 순서로 진행됩니다.

> 🏔 백업, 복원이 각각 한..참 걸리니 참고해주세요.

7. 잘 되었나 보기

화면 위에 [Installation Finished]라 뜨고, 가운데 메시지에 뭐 수상한 메시지가 없으면 성공!

- 1G 고르셨으면 이걸로 끝, [Reboot] 선택해서 재부팅시키고 그냥 쓰시면 됩니다. 공식 "파티션 재조정"도 막상 돌려보면 별 것 없는 것처럼요.

- 그러나 통합 고르셨으면 여기서 끝이 아닙니다, 다음 단계로!
> ❌ 바로 [Reboot] 하시면 여러모로 곤란해집니다. 부팅은 잘 되겠지만 사용자 공간이 마치 사라진 것처럼 나타날 수 있습니다.


8. (통합 선택 시) 한 번 더 루팅

- (SD 카드 **없으면**) 루팅 패키지 파일을 지금 넣어야 하는데, 그 전에 임시 공간을 한 번 비워주어야 합니다.

SD 카드가 없으니 시스템 파일을 쪼매만한 임시 공간에 백업했었고, 전체 500MB 가량인 임시 공간이 거의 차 있는 상황입니다.

7단계에서 리파티션 잘 된 것 보았으니 자신있게 다음 명령으로 임시 파일 삭제하겠습니다.

> `adb shell rm -r /tmp/backup_*`

다음, 아래 명령으로 루팅 패키지 기기에 넣으세요.

> `adb push update/update_mod_r13_full_w_recv_emusd.zip /tmp/`

cf) 올인원이 싫으시면 full 대신 light로 하셔도 됩니다.

- (SD 카드 **있으면**) 이미 2단계에서 넣어두었을 겁니다

이제 5단계와 같이 하되, 이번에는 루팅 패키지를 골라 설치 진행하시면 됩니다.

루팅하실 때도 느끼셨듯이 루팅 패키지 설치 자체는 순식간에 진행되죠.

다 되었으면 [Reboot] 선택해서 재부팅시키고 그냥 쓰시면 됩니다!

끝!


## 순정 복구

다행인지 순정 **파티션 재조정** 기능이 있으니 걱정할 것이 없습니다. 다만 순서가 있습니다!

 * 중요 데이터를 ... 이미 백업하셨죠?
 * 순정 리커버리 파일로 되돌려야 합니다.
   * 루팅 도구 설명의 순정 복구 절차를 따르되, `recovery.img` 명령만 내려주세요.
 * 이제 재부팅 후, 리디 앱 설정에서 **파티션 재조정** 기능을 실행해주세요.
 * 패키지 다운로드 > 리커버리로 재부팅 > 순정 구성으로 파티션 재조정 > 재부팅 되는 것 구경하면 끝이죠.


---

[release]:https://github.com/limerainne/PaperProKitchen/releases
[release-target]:https://github.com/limerainne/PaperProKitchen/releases/tag/repart_r2_r13_2
[release-target-badge]:https://img.shields.io/github/downloads/limerainne/PaperProKitchen/repart_r2_r13_2/PaperPro_repart_tools_r2_r13_2.zip?style=for-the-badge
[repart-branch]:https://github.com/limerainne/PaperProKitchen/tree/repart

[paper_pro-brochure]:https://paper.ridibooks.com/pro/
[detailed_guide]:https://cafe.naver.com/bookbook68912/17551
