# 로컬 ZMK 빌드 메모

## 현재 상황
`easysplit-zmk-config` 저장소는 ZMK 설정 저장소다.

따라서 이 저장소 루트에서 바로 아래 명령을 실행하면 실패한다.

```bash
west init -l .
```

이 명령은 현재 폴더에 `west.yml` 매니페스트가 있을 때 사용하는 방식이다. 현재 저장소는 아직 `west.yml`을 가진 ZMK 워크스페이스가 아니므로 `no west.yml found` 오류가 정상이다.

## 로컬 작업 방향
개인 노트북에서는 아래처럼 작업한다.

```text
~/personal/easysplit-zmk-config   = 내가 관리하는 키보드 설정 저장소
~/zmk-workspace                   = ZMK 본체와 Zephyr를 내려받는 빌드 워크스페이스
```

즉, 설정 저장소와 ZMK 워크스페이스를 분리한다.

## 다음 작업
ZMK 본체를 별도 워크스페이스에 내려받는다.
