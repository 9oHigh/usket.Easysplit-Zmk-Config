# GitHub 커밋 귀속 규칙

## 표준 커밋 계정

Codex, 다른 에이전트, 명령행에서 작성하는 커밋은 다음 계정을 사용합니다.

- 이름: `9oHigh`
- 이메일: `usKet@icloud.com`
- `user.useConfigOnly`: `true`

이 이메일은 GitHub 계정에서 인증된 기본 이메일이며, 공개 커밋에 표시되는 점을 사용자가 허용했습니다. `noreply` 주소나 Mac 호스트명에서 자동 생성된 이메일로 바꾸지 않습니다.

새 clone에서는 커밋 전에 `scripts/install-github-attribution-guards.sh`를 실행합니다. 이 스크립트는 저장소별 Git identity와 `.githooks` 경로를 설정합니다.

## 검사

- `pre-commit`은 새 커밋의 author와 committer가 모두 `9oHigh <usKet@icloud.com>`인지 확인합니다.
- `pre-push`와 GitHub Actions는 새로 푸시되거나 PR에 추가된 커밋의 author가 표준 계정인지 검사합니다. committer는 표준 계정 또는 GitHub 웹 커밋의 `GitHub <noreply@github.com>`을 허용합니다.
- 원격 기준 커밋을 확인할 수 없으면 pre-push는 안전하게 푸시를 중단합니다.
- GitHub Actions 검사를 보호 규칙에서 필수 상태 검사로 설정하지 않으면 알림 역할만 합니다.
- Hook 오류를 `--no-verify`로 우회하지 않습니다. 먼저 올바른 저장소 설정을 설치하고 원인을 고칩니다.

GitHub 기여 그래프는 계정에 연결된 이메일로 작성된 커밋 중 기본 브랜치 또는 `gh-pages`에 반영된 커밋을 집계합니다. 기준: [기여 누락 문제 해결](https://docs.github.com/en/account-and-profile/how-tos/contribution-settings/troubleshooting-missing-contributions), [기여 기준](https://docs.github.com/en/account-and-profile/reference/profile-contributions-reference).
