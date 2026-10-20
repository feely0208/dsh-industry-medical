import { createPlugin, pkgRootFrom } from '@deepwhale-cn/dsh-guard-core/plugin';

export const { name, inject, apply } = createPlugin({
  name: 'industry-medical',
  pkgRoot: pkgRootFrom(import.meta.url),
  skillFile: 'skill/industry-medical.md',
  binFile: 'bin/cli.mjs',
  description: '医疗行业多出来的那几项，别等测评才发现',
  whenToUse: '医院、诊所、互联网医疗、医疗信息化厂商的项目做上线前自查或等保/医疗行业测评准备时使用。用户会说：病历要存多少年、处方保存期限够不够、电子病历有没有留痕、医疗设备网络安全制度有没有、新建项目网络安全预算够不够 5%、外包合同有没有网络安全条款、人脸识别能不能只用一种方式、基因/生物样本项目有没有伦理批件和知情同意。',
});
