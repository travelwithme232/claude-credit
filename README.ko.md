# credit

[English](README.md)

Claude Max·Ultra·Team 요금제에 딸린 월 API 크레딧(프로모션 크레딧)으로 `claude -p` 를 돌리고,
작은 터미널 도구입니다.

> 비공식 도구입니다. Anthropic 이 만들거나 관련된 도구가 아닙니다.

맥·윈도우. Claude Code(`claude`)와 파이썬 3(표준 라이브러리만, 윈도우는 `install.ps1` 이 까는 `keyring` 패키지도)이
있어야 합니다.

## 크레딧 대상

공식 문서([API credits for subscribers](https://platform.claude.com/docs/en/about-claude/api-credits-for-subscribers))에
따르면 크레딧은 **자기 API 키**로 직접 부른 API 에 쓰입니다. 그렇게 돌린 `claude -p` 와 Agent SDK 도 포함됩니다.
대화형 Claude Code 와 IDE 확장은 **대상이 아닙니다.**

- **받을 수 있는 사람** (2026년 11월 기준): Claude **Max·Ultra·Team** 요금제 (Pro 는 안 됨), 가입하고 7일 뒤부터.
- **받는 법** (처음 한 번만, 그 뒤로는 매달 자동): claude.ai **웹사이트**(앱 아님) > **설정 > 결제 > API 크레딧**에서
  내 Claude Console 계정을 연결하세요. Console 에서는 "조직"이라고 부르는데, 혼자 쓰면 그냥 내 계정입니다.

## Console 설정 꼭 하기

그 조직에서 **자동 충전을 끄세요**. 그러면 저절로 돈이 나가지 않고, 크레딧을 다 쓰면 그냥 멈춥니다.
확인: <https://platform.claude.com/settings/billing>. 그다음 같은 조직에서 API 키를 만드세요.

## 어떻게 작동하나요

```
VS Code 의 Claude Code 채팅                     credit (터미널 프로그램)
──────────────────────────                     ────────────────────────
"credit 써서 이 버그 고쳐줘"
   │  CLAUDE.md 의 credit 규칙을 보고
   │  직접 하지 않고 넘김
   └──────── credit run "이 버그 고쳐줘" ───▶  키체인에서 API 키를 꺼내
                                                claude -p 를 API 키로 실행
                                                (= 크레딧에서 빠짐)
                                                파일 읽기·고치기·명령 실행
   ┌──────── 답 + "이번 X불 · 이번 달 Y불" ◀──┘
   ▼
답을 짧게 전해 줌
```

1. **설치하면** `~/.claude/CLAUDE.md` 에 credit 규칙이 들어가요. "credit 써서 해줘"라고 하면 그 작업을 직접 하지 말고
   `credit run` 으로 넘기라는 규칙이에요(표시줄 사이에만 넣고 다른 내용은 안 건드림).
2. **"credit 써서 해줘"라고 하면** 채팅의 Claude 는 일을 직접 하지 않고 `credit run "할 일"` 을 뒤에서 돌려요.
3. **`credit run`** 은 키체인에 저장한 API 키로 `claude -p` 를 실행해요. 로그인 정보는 넘기지 않아서 요금제 사용량이 아니라
   **크레딧**에서 빠져요. 실제 작업(파일 읽고 고치기, 명령 실행)은 여기서 해요.
4. **끝나면** 답과 쓴 금액을 채팅의 Claude 에게 돌려주고, Claude 는 그걸 짧게 전해 줘요. 채팅 쪽은 결과만 받으니
   요금제 사용량을 거의 안 써요.
5. **프로젝트 폴더마다** 대화 하나가 이어져서 앞에서 한 일을 기억해요. "새 대화로"라고 하면 새로 시작해요.
6. **크레딧을 다 쓰면** API 가 멈추고, `credit` 이 "크레딧을 다 썼어요"를 알려 줘요. 그러면 채팅의 Claude 가
   "여기서 직접 할까요?"라고 물어요.

## 설치

```sh
git clone https://github.com/travelwithme232/claude-credit.git
cd claude-credit
./install.sh                                              # 맥
powershell -ExecutionPolicy Bypass -File install.ps1      # 윈도우
```

또는 **install.command**(맥)나 **install.bat**(윈도우)을 더블클릭하세요. 받은 zip 은 실행 권한이 빠지고 격리되므로
처음엔 **우클릭 > 열기**로 여세요(윈도우에서 SmartScreen 이 막으면 "추가 정보 > 실행").

`credit` 을 `~/.local/bin/` 에 복사하고(윈도우는 `credit.py` + `credit.cmd`, 덮어쓰기 전에 묻습니다) VS Code 연동을 켭니다:
`~/.claude/CLAUDE.md` 에 표시줄(`<!-- credit:start -->` … `<!-- credit:end -->`)로 감싼 규칙과
`~/.claude/commands/credit-result.md`. 그러면 Claude Code 에서 "credit 써서 해줘"라고 하면 `credit run` 으로 백그라운드에서
넘깁니다. CLAUDE.md 의 다른 내용은 건드리지 않습니다.

## 쓰는 법

평소엔 Claude Code 채팅에서 **"credit 써서 해줘"** 라고만 하면 됩니다. 예: "credit 써서 이 버그 고쳐줘".
크레딧으로 뒤에서 돌리고, 끝나면 답과 쓴 금액을 알려 줍니다.

설정 명령:

```
credit                         상태: 이번 달 쓴 금액·설정·키
credit help                    credit 설명·설정·명령·비용
credit key                     자동 충전 꺼짐 확인 후 API 키 넣기 (안 보임)
credit set cap|model 값        안 해도 됨 (기본값으로 잘 돌아가요):
                                 cap = 한 번에 쓸 수 있는 최대 금액 (기본 10불, 넘으면 멈춤)
                                 model = auto (그 대화에서 쓰던 모델, 처음이면 opus) | opus | sonnet | fable
credit uninstall               credit 이 깐 것 전부 지우기 (먼저 물음)
```

- **넣을 것 없음**: 자동 충전이 꺼져 있으면 크레딧을 다 쓰거나 만료될 때 API 가 알아서 멈춥니다. 그러면 영어 오류 대신
  "크레딧을 다 썼어요" 안내가 나오고, Claude Code 가 여기서 직접 할지 물어봅니다. 그 순간 하던 일은 중간에 끊길 수 있습니다.
- 프로젝트 폴더마다 대화 하나가 계속 이어집니다. 새로 시작하려면 "credit 새 대화로 해줘". 대화가 길수록 한 번에 비싸지니
  일이 끝나면 새 대화로 시작하세요. 기본 모델 `auto` = 그 대화의 마지막 모델, 없으면 opus.

파일: `~/.claude/credit/config.json`(설정), `spend.json`(메시지별 금액). 키는 맥 키체인 / Windows 자격 증명 관리자에만
있습니다(항목 이름 `claude-credit`).

## 비용 주의

- 긴 대화는 지난 내용을 다시 보내므로 메시지 한 번에 몇 불이 들 수 있습니다.
- 프롬프트 캐시는 5분쯤 갑니다. 5분 안에 이어 쓰면 훨씬 쌉니다.
- 모델마다 값 차이가 큽니다. sonnet 이 opus 보다 쌉니다.

100만 토큰당 요금(2026-11 기준, 바뀔 수 있음 —
[요금 문서](https://platform.claude.com/docs/en/about-claude/pricing)):

| 모델 | 입력 | 출력 | 캐시 읽기 |
|---|---|---|---|
| Fable 5.1 | 10불 | 50불 | 0.25불 |
| Opus 5.5 | 4불 | 20불 | 0.20불 |
| Sonnet 5.5 | 2불 | 10불 | 0.10불 |

페이블은 오퍼스의 2.5배라서 평소엔 opus 를 추천합니다(기본 모델이 fable 이면 `credit` 상태 화면에 경고가 나옵니다).
예: 긴 대화(약 25만 토큰)를 처음(또는 5분 넘게 쉬고) 이어 쓰면 읽는 값만 페이블 약 3불, 오퍼스 약 1.3불. 5분 안이면 몇 센트입니다.

`claude` 는 `ANTHROPIC_API_KEY` 와 기본값(HOME·PATH 등)만 넣은 깨끗한 환경에서 돕니다. VS Code 환경변수가 넘어가면
크레딧 대신 구독으로 돌기 때문입니다. `--bare` 는 쓰지 않습니다.

## 지우기

```sh
credit uninstall
```

확인을 물은 뒤 `~/.claude/CLAUDE.md` 의 credit 부분만(다른 내용은 그대로), `credit-result.md`, `~/.claude/credit/`,
API 키, `credit` 프로그램 자신까지 지우고, 지운 것 목록을 보여 줍니다.

## 라이선스

MIT
