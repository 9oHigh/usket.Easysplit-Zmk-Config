# GitHub 커밋 귀속 규칙

## 이 저장소의 표준 커밋 계정

명령행이나 에이전트가 만드는 커밋은 다음 GitHub 연결 이메일을 사용합니다.

- 이름: `LEE GYEONG HU`
- 이메일: `53691249+9oHigh@users.noreply.github.com`
- `user.useConfigOnly`: `true`

새 clone에서는 커밋 전에 `scripts/install-github-attribution-guards.sh`를 실행합니다. 이 스크립트는 저장소별 Git identity와 `.githooks` 경로를 설정합니다.

## 실패 차단 및 검사

- `pre-commit`은 author와 committer 이메일이 표준 이메일과 다르면 커밋을 중단합니다.
- `pre-push`는 새로 푸시될 커밋의 author와 committer 이메일을 검사합니다. 원격 기준 커밋을 확인할 수 없으면 안전하게 푸시를 중단합니다.
- GitHub Actions는 push와 pull request에 새로 추가된 커밋을 검사합니다. 이 검사는 보호 규칙에서 필수 상태 검사로 설정하지 않는 한 알림 역할을 합니다.
- Hook 오류를 `--no-verify`로 우회하지 않습니다. 먼저 올바른 저장소 설정을 설치하고 원인을 고칩니다.

GitHub 기여 그래프는 커밋 이메일이 계정에 연결돼 있고, 독립 저장소의 기본 브랜치 또는 `gh-pages`에 있는 커밋을 반영합니다. 기준: [기여 누락 문제 해결](https://docs.github.com/en/account-and-profile/how-tos/contribution-settings/troubleshooting-missing-contributions), [기여 기준](https://docs.github.com/en/account-and-profile/reference/profile-contributions-reference).
