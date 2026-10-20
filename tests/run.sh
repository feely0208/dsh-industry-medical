#!/bin/bash
# 双向验证：正例必须报，反例必须不报（误报是安全工具的头号杀手）
set -uo pipefail
export PATH="/usr/local/bin:$PATH"
cd "$(dirname "$0")/.."
PASS=0; FAIL=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
bad(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }

RULES="MED-EMR-RETENTION-1 MED-EMR-RETENTION-2 MED-EMR-AUDIT-TRAIL-1 MED-EMR-AUDIT-TRAIL-2 MED-PRESCRIPTION-RETENTION MED-DEVICE-CYBER-POLICY MED-CYBER-BUDGET-5PCT MED-VENDOR-CYBER-CLAUSE MED-FACE-FALLBACK MED-HGR-ETHICS-CONSENT-1 MED-HGR-ETHICS-CONSENT-2"

echo ""; echo "  $(node -p "require('./package.json').name") · 双向验证"
echo "  ────────────────────────────────────────────────"

json_count() { # $1=json  $2=ruleId
  echo "$1" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    print(len([f for f in d.get('findings',[]) if f.get('ruleId')=='$2']))
except Exception:
    print(0)" 2>/dev/null
}

echo ""; echo "  【正例】tests/fixtures/fail/demo-project（11 条判据逐条都必须报出）"
J=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --json 2>&1)
for rid in $RULES; do
  c=$(json_count "$J" "$rid")
  [ "${c:-0}" -gt 0 ] && ok "$rid 报出（$c 处）" || bad "$rid 未报出"
done
N=$(echo "$J" | python3 -c "
import json,sys
try: print(len(json.load(sys.stdin).get('findings',[])))
except Exception: print(-1)" 2>/dev/null)
[ "${N:-1}" = "11" ] && ok "正例总命中 11 条（每条判据恰好一处，无重复上报）" || bad "正例总命中 ${N} 条，期望 11"

echo ""; echo "  【反例】tests/fixtures/pass/clean-project（必须 0 命中，含边界样本）"
M=$(node bin/cli.mjs --root tests/fixtures/pass/clean-project --json 2>&1 | python3 -c "
import json,sys
try: print(len(json.load(sys.stdin).get('findings',[])))
except Exception: print(-1)" 2>/dev/null)
[ "${M:-1}" = "0" ] && ok "干净样本 0 命中（15/30 年病历、1/2/3 年处方、留痕字段、审计表、设备制度、8% 预算、合同条款、人脸+密码、伦理与知情同意均合规）" || bad "误报 ${M} 条"

echo ""; echo "  【不适用】tests/fixtures/na/web-only（纯前端项目，when 应全部跳过而不是误报）"
A=$(node bin/cli.mjs --root tests/fixtures/na/web-only --json 2>&1)
NA=$(echo "$A" | python3 -c "
import json,sys
try: print(len(json.load(sys.stdin)['stats'].get('notApplicable') or []))
except Exception: print(-1)" 2>/dev/null)
AF=$(echo "$A" | python3 -c "
import json,sys
try: print(len(json.load(sys.stdin).get('findings',[])))
except Exception: print(-1)" 2>/dev/null)
[ "${NA:-0}" = "11" ] && ok "11 条规则全部因 when 不适用而跳过" || bad "when 跳过 ${NA} 条，期望 11"
[ "${AF:-1}" = "0" ] && ok "不适用项目 0 命中（行业规则不会误伤纯软件项目）" || bad "不适用项目误报 ${AF} 条"

echo ""; echo "  【结构】所有判据单 check、行业规则必须带 when、exts 必须带点"
python3 - <<'PY' && ok "规则结构检查通过" || bad "规则结构检查失败"
import json, glob, sys
bad = 0
for f in sorted(glob.glob('rules/*.json')):
    r = json.load(open(f, encoding='utf-8'))
    c = r.get('check') or {}
    if not c.get('type'):
        print('缺 check.type:', r.get('id'), file=sys.stderr); bad += 1
    if not c.get('when'):
        print('行业规则缺 when:', r.get('id'), file=sys.stderr); bad += 1
    for ext in (c.get('exts') or []):
        if not ext.startswith('.'):
            print('exts 不带点:', r.get('id'), ext, file=sys.stderr); bad += 1
sys.exit(1 if bad else 0)
PY

echo ""; echo "  【溯源】每条规则必须带条款号 source，且 advice ≥40 字"
python3 - <<'PY' && ok "11 条规则均有可查证 source 与足够长的 advice" || bad "有规则缺 source / 条款号 / advice 过短"
import json, glob, sys
bad = 0
for f in sorted(glob.glob('rules/*.json')):
    r = json.load(open(f, encoding='utf-8'))
    src = r.get('source') or ''
    if not src:
        print('缺 source:', r.get('id'), file=sys.stderr); bad += 1
    elif not any(k in src for k in ('第', '令', '条')):
        print('source 无可查条款号:', r.get('id'), file=sys.stderr); bad += 1
    if len(r.get('advice') or '') < 40:
        print('advice 过短:', r.get('id'), file=sys.stderr); bad += 1
sys.exit(1 if bad else 0)
PY

echo ""; echo "  【数量】规则库应有 11 条（8 条判据，其中 1/2/8 各拆两条 check）"
RC=$(ls rules/*.json 2>/dev/null | wc -l | tr -d ' ')
[ "$RC" = "11" ] && ok "规则数 11" || bad "规则数 ${RC}，期望 11"

echo ""; echo "  ────────────────────────────────────────────────"
echo "  通过 $PASS · 失败 $FAIL"; echo ""
[ "$FAIL" -eq 0 ] || exit 1
