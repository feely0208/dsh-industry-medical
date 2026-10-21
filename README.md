# @deepwhale-cn/dsh-industry-medical

[![dshfind 收录](https://dshfind.com/api/badge/feely0208/dsh-industry-medical?lang=zh)](https://dshfind.com/zh/plugins/feely0208/dsh-industry-medical)

[![Listed on dsh-plugin.org](https://dsh-plugin.org/badges/listed.svg)](https://dsh-plugin.org/zh/plugins/feely0208/dsh-industry-medical)

**别等医疗行业测评时才发现：病历少存了 5 年、处方只留了 180 天、病历改过却查不到是谁改的、新建项目网络安全预算只给了 3%、人脸登录没有替代方式、基因样本项目拿不出伦理批件。**

**关键词**：医疗 医院 病历 电子病历 处方 合规 等保 医疗设备网络安全 人类遗传资源 人脸识别

---

## 先说清楚它是什么、不是什么

**是**：针对**医疗行业特有要求**的静态自查。它检查一个医疗信息化项目里那些「通用安全工具不查、但医疗行业测评一定会问」的点：病历/处方保存期限、病历操作留痕、医疗设备全生命周期网络安全制度、新建项目 5% 网络安全预算、外包合同网络安全条款、人脸识别的非人脸替代方式、人类遗传资源的伦理审查与知情同意。

**不是**：
- ❌ **不是合规认证，也不是「保证通过测评」** —— 它只是把可疑点指出来，让你在测评前自己去确认和补材料
- ❌ **不是通用安全扫描器** —— 等保基线、漏洞、依赖、密钥那些是其它插件的活，这里不重复
- ❌ **不是法律意见** —— 判据只引用条款号与原文要点，最终是否适用请以主管部门解释为准
- ❌ **不下「安全 / 不安全」「合规 / 不合规」的结论** —— 命中 = 提示确认，不是判定违规

**一句话分界**：**别的插件查「所有项目都该有」的，它查「医疗项目才多出来」的。**

---

## 它查什么（8 条判据 / 11 条规则）

| 规则 | 查什么 | 级别 |
|---|---|---|
| `MED-EMR-RETENTION-1` | 病历/EMR 保存期限声明低于门急诊 15 年（5475 天）、住院 30 年（10950 天）| 🔴 |
| `MED-EMR-RETENTION-2` | 有病历相关库表/配置，却找不到写明 15 年 / 30 年的保存期限声明 | 🔴 |
| `MED-EMR-AUDIT-TRAIL-1` | 病历库表/实体缺操作留痕字段（updated_by / 操作人 / version / trace_id）| 🔴 |
| `MED-EMR-AUDIT-TRAIL-2` | 全项目找不到独立操作日志表，也没用框架级审计（Envers / JPA Auditing 等）| 🔴 |
| `MED-PRESCRIPTION-RETENTION` | 处方保存期限低于 1 年（365 天）法定下限（含 <12 个月、0.x 年）| 🔴 |
| `MED-DEVICE-CYBER-POLICY` | 有 DICOM/HL7/PACS/监护/输液泵，却找不到覆盖采购→安装→运行→维护→报废 ≥4 环节的医疗设备网络安全制度 | 🟡 |
| `MED-CYBER-BUDGET-5PCT` | 新建项目的预算/立项/概算文档里，网络安全占比 <5%（纯运维/改造/升级不跑）| 🟡 |
| `MED-VENDOR-CYBER-CLAUSE` | 外包/设备厂商合同没有同时出现「网络安全/数据安全义务」与「违约责任」| 🟡 |
| `MED-FACE-FALLBACK` | 有人脸识别/活体检测，却没有任何非人脸替代方式（密码/短信/人工核验）| 🟡 |
| `MED-HGR-ETHICS-CONSENT-1` | 有基因/生物样本/遗传资源模块，却找不到伦理审查批件或审查记录 | 🟡 |
| `MED-HGR-ETHICS-CONSENT-2` | 有基因/生物样本/遗传资源模块，却找不到知情同意模板或签署记录 | 🟡 |

**每条判据都配了 `when`**：项目里没有对应特征（没有病历、没有处方、没有医疗设备、没有人脸、没有基因模块……）时，规则进「不适用」而不是硬报 —— 纯软件项目不会被误伤。

### 一条判据为什么可能是两条规则

`file-pattern`（匹配到违规写法就报）和 `files-lack`（全项目找不到才报）是**相反的语义**，一条规则只能有一个 check。所以：

- 病历保存期限 = 「写短了」(`-1`) + 「根本没写合规声明」(`-2`)
- 病历留痕 = 「表里缺字段」(`-1`) + 「全项目没有审计机制」(`-2`)
- 人类遗传资源 = 「缺伦理批件」(`-1`) + 「缺知情同意」(`-2`)（对外提供备案只在跨境场景适用，写进建议里，不单独硬报）

### 出处（条款号已核对原文，不扩写）

- 《电子病历应用管理规范（试行）》（国卫办医发〔2017〕8号）**第十四条、第十六条、第十九条**
- 《医疗机构病历管理规定（2013年版）》（国卫医发〔2013〕31号）**第二十九条**
- 《处方管理办法》（卫生部令第53号）**第五十条**
- 《医疗卫生机构网络安全管理办法》（国卫规划发〔2022〕29号）**第四条第二款、第十四条、第二十二条（六）、第三十条**
- 《中华人民共和国人类遗传资源管理条例》（国务院令第717号）**第九条、第二十八条**

---

## 安装

```bash
dsh plugin --profile web add @deepwhale-cn/dsh-industry-medical
```

## 用法

```bash
# 检查当前项目
dsh-industry-medical

# 检查指定目录
dsh-industry-medical --root /path/to/his-project

# 看内置演示（一个「看起来挺正常、医疗行业该有的都没写」的样本项目）
dsh-industry-medical --demo

# 列出判据与出处
dsh-industry-medical --list-rules

# 出 HTML 报告（测评前留档）
dsh-industry-medical --root . --html medical.html

# 给 CI 用：有 high 命中时退出码 1
dsh-industry-medical --root . --quiet
```

---

## 一个真实的例子

`--demo` 的样本项目看起来很正常：有 `package.json`、有 Spring 配置、有 DDL、有信息安全制度、有合同、有登录控制器。
但把它当医疗项目看，问题就一个接一个浮出来：

```
🔴 病历保存期限写的是 10 年                            config/application-medical.yml:7
🔴 全项目找不到写明 15/30 年的病历保存期限声明          (全局)
🔴 电子病历表只有 id/patient_id/content/created_at      db/schema/emr_record.sql
🔴 全项目找不到操作日志表或框架级审计                   (全局)
🔴 处方保存期限写的是 180d                              config/application-medical.yml:10
🟡 有 DICOM/PACS，但没有医疗设备网络安全制度            docs/**
🟡 新建项目网络安全预算只占 3%                          docs/立项报告.md:17
🟡 运维服务合同只有 SLA，没有网络安全义务与违约责任       contracts/运维服务合同.txt
🟡 人脸识别登录，没有密码/短信等替代方式                  (全局)
🟡 有基因组样本采集，找不到伦理审查批件                   (全局)
🟡 有基因组样本采集，找不到知情同意模板                   (全局)
```

而 `tests/fixtures/pass/clean-project` 里同样的结构、每条都合规，
还有一堆**边界写法**（15/30 年病历、1/2/3 年处方、`365d`/`1095d`、ODS 临时表 180 天、纯运维预算 3%、人脸+密码登录、PRIMARY KEY 自带 version 字段……）—— 一条都不报。

**「有配置」和「配置对、证据齐」是两件事**，这个工具查的就是后者。

---

## 边界

- **只读静态文本**：不连数据库、不跑项目、不验真伪。配置文件里写 30 年 ≠ 系统真的留 30 年；合同里写了条款 ≠ 实际执行。它只反映「仓库里能不能找到证据」。
- **只覆盖医疗行业增量**：等保基线、漏洞、依赖、密钥轮转、数据出境等请配合其它插件一起用。
- **`when` 是启发式**：用关键词判断项目是否具备某特征。如果项目把医疗业务放在别的仓库、或敏感模块不在本仓库，规则会进「不适用」—— 这不是「没问题」，而是「这里没查到」。
- **制度/合同类判据是「找不到就提示」**：文档可能放在 OA、纸质档案或别的仓库。命中了先确认它是不是在别处，别急着补一份假的。
- **人类遗传资源的对外提供备案**只在跨境/向外方提供场景适用，本插件不单独硬报，见 `MED-HGR-ETHICS-CONSENT-2` 的建议。

---

## 和现有 31 个插件不重叠在哪

现有插件绝大多数在查**所有项目都该有**的通用项（等保基线、日志留存、个人信息、数据出境、密钥、依赖、SBOM、CI 安全等）。
`dsh-industry-medical` 只查**医疗行业特有的、测评问卷里多出来的那几项**：病历与处方的法定保存年限、病历操作留痕、医疗设备全生命周期网络安全制度、新建项目 5% 网络安全预算、厂商合同安全条款、人脸识别的非人脸替代、人类遗传资源的伦理与知情同意。
它不重复通用检查，通用检查也不覆盖这些医疗专属判据。

## 深鲸网安守护系列（共 39 个）

> 一个插件做一件事。**安全问题是链式的** —— 配套用才完整。

**国内合规**（12）｜ [等保对照](https://github.com/feely0208/dsh-cn-mlps) · [日志留存](https://github.com/feely0208/dsh-cn-log-retention) · [备案公示](https://github.com/feely0208/dsh-cn-filing) · [用户同意](https://github.com/feely0208/dsh-consent-guard) · [个人信息权利](https://github.com/feely0208/dsh-data-rights) · [未成年人保护](https://github.com/feely0208/dsh-minor-guard) · [影响评估](https://github.com/feely0208/dsh-pipia) · [数据分类分级](https://github.com/feely0208/dsh-data-classify) · [算法备案](https://github.com/feely0208/dsh-algorithm-filing) · [数据出境](https://github.com/feely0208/dsh-cn-data-export) · [国密合规](https://github.com/feely0208/dsh-cn-crypto) · [AI 内容标识](https://github.com/feely0208/dsh-cn-ai-labeling)

**AI 与 Agent 治理**（6）｜ [AI 输出信任](https://github.com/feely0208/dsh-ai-output-trust) · [外部内容信任](https://github.com/feely0208/dsh-content-trust) · [MCP 安全](https://github.com/feely0208/dsh-mcp-audit) · [Agent 权限](https://github.com/feely0208/dsh-agent-scope) · [策略核对](https://github.com/feely0208/dsh-agent-policy) · [可疑指令](https://github.com/feely0208/dsh-phishing-guard)

**数据与凭据**（5）｜ [敏感数据](https://github.com/feely0208/dsh-data-scan) · [密钥轮换](https://github.com/feely0208/dsh-key-rotate) · [数据留存](https://github.com/feely0208/dsh-data-lifecycle) · [配置审计](https://github.com/feely0208/dsh-env-audit) · [密钥扫描](https://github.com/feely0208/dsh-secret-scan)

**供应链与构建**（5）｜ [开源许可](https://github.com/feely0208/dsh-license-guard) · [依赖投毒](https://github.com/feely0208/dsh-dep-audit) · [CI 安全](https://github.com/feely0208/dsh-ci-guard) · [工具审查](https://github.com/feely0208/dsh-tool-vet) · [物料清单](https://github.com/feely0208/dsh-sbom)

**权限与应急**（3）｜ [最小权限](https://github.com/feely0208/dsh-least-privilege) · [告警外发](https://github.com/feely0208/dsh-alert-relay) · [应急证据包](https://github.com/feely0208/dsh-incident-package)

**行业专项**（4）｜ [医疗行业专项](https://github.com/feely0208/dsh-industry-medical) · [教育行业专项](https://github.com/feely0208/dsh-industry-education) · [金融行业专项](https://github.com/feely0208/dsh-industry-finance) · [地方数据条例](https://github.com/feely0208/dsh-local-regulation)

**编排与交付**（4）｜ [一键体检](https://github.com/feely0208/dsh-guard-suite) · [改前改后复核](https://github.com/feely0208/dsh-fix-verify) · [合规可交付文档](https://github.com/feely0208/dsh-compliance-doc) · [整改建议](https://github.com/feely0208/dsh-remediation)

都在 DSH 插件市场（dsh-plugin.org）、npm 和 deepwhale.org.cn/guard.html 上。
