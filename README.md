# TDFeTributacaoRT - Componente para Reforma Tributária

## 🎯 **Descrição Geral**

O **TDFeTributacaoRT** é um componente Delphi desenvolvido para implementar os cálculos da **Reforma Tributária brasileira**, incluindo o Imposto sobre Bens e Serviços (IBS), a Contribuição sobre Bens e Serviços (CBS) e o Imposto Seletivo (IS). Este componente foi projetado para trabalhar integrado com o componente ACBrNFe, facilitando a implementação das novas regras tributárias que entram em vigor em 2026.

### ✨ **Características Únicas**

- 🔥 **Elimina 100% da Rejeição 1103** - Base sempre correta e informada
- 📊 **Alíquotas Conformes 2025/2026** - IBS UF: 0.10%, IBS Mun: 0.00%, CBS: 0.90%
- 🎯 **Base de Cálculo Livre** - Totalmente controlada por parâmetro
- 🏗️ **Arquitetura Robusta** - Singleton + Interface Fluente
- 📝 **XML Autorizado SEFAZ** - 100% conforme manual UB05-UB10
- 🧪 **6 Cenários Testados** - Demo completo com validação real

---

## 🛠️ **Design Pattern e Arquitetura**

### Padrão de Design Implementado
O componente utiliza uma arquitetura híbrida avançada:

```delphi
// Padrão Singleton + Interface Fluente
TDFeTributacaoRT
  .ACBr(ACBrNFe1)           // Injeta dependência
  .CST('200')               // Define situação tributária
  .BaseIBSCBS(100.00)       // 🚨 OBRIGATÓRIO - Base informada
  .AliquotaIBSUF(0.10)      // Alíquota IBS UF 2025/2026
  .ReducaoAliqIBS(100.0)    // Redução na alíquota
  .Calcular;                // Executa e retorna Self
```

### Vantagens da Implementação

1. **Fluent Interface**: Encadeamento intuitivo de métodos
2. **Class Methods**: Uso sem necessidade de instanciação
3. **Singleton**: Garante consistência dos cálculos
4. **Injeção de Dependência**: Flexibilidade total com ACBr

---

## 📊 **Funcionalidades Implementadas**

### Cálculo Tributário Completo

#### 🏷️ **IBS (Imposto sobre Bens e Serviços)**
- **IBS Estadual** (IBS UF): Partilha para estados
- **IBS Municipal** (IBS Mun): Partilha para municípios
- **Base Livre**: Controlada 100% por parâmetro
- **Redução de Alíquota**: Aplicada apenas na alíquota
- **Diferimento**: Aplicado no valor do imposto

#### 📄 **CBS (Contribuição sobre Bens e Serviços)**
- Cálculo independente com alíquota própria
- Suporte a redução e diferimento
- Base compartilhada com IBS (vBC)

#### 🔍 **Imposto Seletivo (IS)**
- Preparado para vigência em 2027
- Alíquotas específicas por produto
- Unidade tributável específica

#### 💡 **Benefícios Fiscais**
- **Redução de Alíquota**: `pAliqEfet = pAliq × (1 - pRedAliq/100)`
- **Diferimento**: `vDiferido = vImposto × (pDif/100)`
- **Crédito Presumido**: Suporte completo implementado
- **Transferência de Crédito**: Entre estabelecimentos

---

## 🚀 **Diferenciais Competitivos**

### ✅ **Princípios Fundamentais (Nunca Violados)**

1. **🔒 Base NUNCA é Reduzida**
   ```delphi
   // ✅ CORRETO - Base intacta
   .BaseIBSCBS(1000.00)      // Base informada
   .ReducaoAliqIBS(20.0)     // Reduz ALÍQUOTA

   // ❌ ERRADO - Não faça isso!
   // BaseIBSCBS := BaseIBSCBS * 0.80;
   ```

2. **📋 Base SEMPRE Informada**
   ```delphi
   // Base é OBRIGATÓRIA
   .BaseIBSCBS(100.00)  // Parâmetro obrigatório

   // Erro se não informada:
   // "Base de cálculo não foi informada!"
   ```

3. **⚡ Redução Apenas na Alíquota**
   ```delphi
   // Fórmula implementada:
   // pAliqEfet = 2.5% × (1 - 60%) = 1.0%
   ```

4. **💰 Diferimento no Valor**
   ```delphi
   // vDiferido = vImposto × pDif%
   // vDevido = vImposto - vDiferido
   ```

---

## 🏗️ **Estrutura do Projeto**

### Organização dos Arquivos
```
TDFeTributacaoRT/
├── 📄 DFeTributacaoRT.pas           # Unidade principal do componente
├── 📁 Demo RT/                       # Projeto demonstração COMPLETO
│   ├── 🎯 Frm_ACBrNFe.pas/.dfm      # Form com 6 cenários práticos
│   │   └── 🎛️ Exemplos_Reforma_trib  # Painel interativo
│   ├── 📋 RT_ExemplosUso.pas        # Funções auxiliares
│   └── 📦 ACBrNFe_Exemplo.dpr        # Aplicação demo
├── 📁 Documentação/
│   ├── 📖 README_NOVO.md             # Documentação principal
│   ├── 📝 CENARIOS_IMPLEMENTADOS.md   # Detalhes dos 6 cenários
│   ├── 🔧 CORRECAO_XML_ESTRUTURA.md  # Correções aplicadas
│   └── 📚 DEMO_IMPLEMENTADO.md        # Guia do demo
├── 📁 Manuais Técnicos/               # Documentação oficial
│   ├── 📄 NT_2025.002_v1.xx_RTC_NF-e_IBS_CBS_IS.pdf
│   └── 📊 CST_cClassTrib_2025-10-03_Public_verde.xlsx
└── 🌐 nuvemtributaria.com.br         # Portal online de suporte
```

---

## 💻 **Como Usar**

### Instalação Rápida
1. **Adicionar ao Library Path**
   ```
   Tools > Options > Delphi Options > Library
   Adicionar: C:\TDFeTributacaoRT
   ```

2. **Adicionar ao Projeto**
   ```delphi
   uses DFeTributacaoRT;
   ```

### Exemplos Práticos

#### 🎯 **NF-e Normal (Base por Item)**
```delphi
// Cenário mais comum
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .CST('010')
  .ClassTrib('000001')
  .BaseIBSCBS(
    vProd + vServ + vFrete + vSeg + vII
  )                     // Base calculada
  .AliquotaIBSUF(0.10)
  .AliquotaCBS(0.90)
  .Calcular;
```

#### 🔥 **NF-e com Redução 100% (Isenção)**
```delphi
// Alíquota efetiva = 0%
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .CST('200')
  .ClassTrib('200003')
  .BaseIBSCBS(1000.00)    // Base intacta
  .AliquotaIBSUF(0.10)
  .AliquotaCBS(0.90)
  .ReducaoAliqIBS(100.0) // 100% de redução
  .ReducaoAliqCBS(100.0) // 100% de redução
  .Calcular;
// Resultado: pAliqEfet = 0.00%
```

#### 💸 **NF-e com Diferimento**
```delphi
// 50% do imposto diferido
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .CST('200')
  .BaseIBSCBS(500.00)
  .AliquotaIBSUF(2.5)
  .DiferimentoIBS(50.0)  // 50% diferido
  .Calcular;
// Resultado: vDevTrib = 50% do valor
```

#### 📝 **NF-e de Juros/Multa (Item Zerado)**
```delphi
// Item com R$ 0,00, base manual
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .CST('200')
  .ClassTrib('200003')
  .BaseIBSCBS(100.00)    // Base informada
  .AliquotaIBSUF(0.10)
  .AliquotaIBSMun(0.00)
  .AliquotaCBS(0.90)
  .ReducaoAliqIBS(100.0)
  .ReducaoAliqCBS(100.0)
  .Calcular;
// Item: vProd = 0
// Base: vBC = 100
```

#### 🌎 **NF-e Importação**
```delphi
// Base = vProd + frete + seguro + II
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .CST('001')
  .BaseIBSCBS(
    5000 +      // vProd
    200 +       // vFrete
    100 +       // vSeg
    1200        // vII
  )
  .AliquotaIBSUF(0.10)
  .Calcular;
```

---

## 📊 **CSTs Suportados**

| CST | Descrição | Aplicação Típica |
|-----|-----------|------------------|
| **000** | Tributada integralmente | Operações normais |
| **010** | Tributada com cobrança IBS/CBS | Vendas com crédito |
| **040** | Isenta | Isenções legais |
| **041** | Não tributada | Não incidência |
| **050** | Suspensão | Exportação |
| **051** | Substituição tributária | ST |
| **200** | Isenta | Benefícios fiscais |
| **201** | Redução de base | Redução legal |
| **202** | Redução base + alíquota | Redução ampla |
| **203** | Redução de alíquota | Redução parcial |
| **400** | Não tributada | Exportação |
| **410** | Não tributada | Zona Franca |
| **500** | Imune | Imunidade |
| **515** | Débito | Lançamento débito |

---

## 🎮 **Demo Interativo**

### Painel de Exemplos Implementados

O componente inclui uma aplicação demo completa com **6 cenários práticos**:

#### 🎛️ **Botões do Painel `Exemplos_Reforma_trib`**

1. **📦 NF Normal**
   - Base: R$ 100,00
   - Sem benefícios
   - Alíquotas padrão

2. **🔖 NF Redução 100%**
   - Classe: 200003
   - pAliqEfet: 0.00%
   - Base intacta

3. **⏳ NF Diferimento Total**
   - 100% diferido
   - vDevTrib: 0.00
   - Grupos gDif presentes

4. **💰 NF Juros e Multa**
   - Item: R$ 0,00
   - Base: R$ 100,00
   - NF de débito

5. **📝 NF Complementar**
   - Base livre
   - NF referenciada
   - CST 090

6. **🌍 NF Importação**
   - Base calculada
   - Com II incluso
   - CFOP específico

### Executando o Demo
```bash
# Abrir projeto
C:\TDFeTributacaoRT\Demo RT\ACBrNFe_Exemplo.dpr

# Compile e execute
# Clique nos botões do painel Exemplos_Reforma_trib
# Visualize o XML gerado em tempo real
```

---

## 🔧 **API Reference**

### Métodos Principais

#### Configuração Obrigatória
```delphi
// Essenciais para qualquer cálculo
.ACBr(TACBrNFe)           // Componente ACBr
.CST(string)               // CST do item
.ClassTrib(string)         // Classe tributária
.BaseIBSCBS(Double)        // 🚨 OBRIGATÓRIO
```

#### Alíquotas Conformes 2025/2026
```delphi
.AliquotaIBSUF(0.10)      // Padrão UF
.AliquotaIBSMun(0.00)     // Padrão Município
.AliquotaCBS(0.90)        // Padrão Contribuição
```

#### Benefícios Fiscais
```delphi
.ReducaoAliqIBS(percentual)    // Reduz alíquota IBS
.ReducaoAliqCBS(percentual)    // Reduz alíquota CBS
.DiferimentoIBS(percentual)    // Diferimento IBS
.DiferimentoCBS(percentual)    // Diferimento CBS
```

#### Execução
```delphi
.Calcular()                 // Calcula item
.CalcularTotalizacao()      // Totaliza NF-e
```

### Propriedades de Resultado
```delphi
// Valores calculados (somente leitura)
FAliquotaIBSUF     // Alíquota aplicada
FBaseIBSCBS       // Base utilizada
vTotalIBSUF       // Valor total IBS UF
vTotalIBSMun      // Valor total IBS Mun
vTotalCBS         // Valor total CBS
```

---

## ✅ **Validações Automáticas**

O componente realiza validações críticas:

### 🔍 **Validações de Cálculo**
- ✅ Base SEMPRE informada (erro se não)
- ✅ CSTs válidos para Reforma Tributária
- ✅ Valores nunca negativos
- ✅ Arredondamento para 2 casas decimais

### 📋 **Regras Fiscais**
- ⛔ **Impede cálculo** para CST (040, 041, 050, 051, 400, 410, 500)
- ⚠️ **IS apenas** a partir de 2027
- ✅ **Grupos XML** sempre gerados
- ✅ **Base intacta** em reduções

---

## 🌐 **Portal de Suporte**

### 📚 **nuvemtributaria.com.br**

Portal completo com:
- 📖 **Documentação detalhada**
- 📝 **Exemplos práticos**
- 🔧 **Tutoriais em vídeo**
- 💬 **Fórum de discussão**
- 📰 **Atualizações da Reforma**
- 🎯 **Casos de uso reais**

### 💻 **Recursos Online**
```delphi
// Acesso rápido aos recursos
📖 Wiki completa
📝 Guias passo a passo
🔥 Exemplos de código
❓ FAQ atualizado
```

---

## 🙏 **Agradecimentos Especiais**

### 🎯 **Edmar Frazão - Especialista Técnico**
- 👨‍💻 **Expertise em Reforma Tributária**
- 🧪 **Validação de XMLs autorizados**
- 📊 **Exemplos reais SEFAZ**
- 🔍 **Testes e validação rigorosa**
- ✅ **Garantia de conformidade**

### 💝 **Carlos Oliveira - Apoiador**
- 🌐 **Doação do domínio** nuvemtributaria.com.br
- 💰 **Investimento na comunidade**
- 🚀 **Suporte ao projeto**
- 📚 **Promoção do conhecimento**
- 🤝 **Compromisso com a educação**

---

## 💰 **Apoie o Projeto**

### 📱 **Contribuição via PIX**
```
🏦 CNPJ: 28.254.501/0001-13
```

Sua doação mantém:
- ✅ **Desenvolvimento contínuo**
- ✅ **Novas funcionalidades**
- ✅ **Suporte gratuito**
- ✅ **nuvemtributaria.com.br online**
- ✅ **Documentação atualizada**

### 🤝 **Outras Formas de Apoio**
- ⭐ **Star no GitHub**
- 🐛 **Report de issues**
- 📝 **Melhorias no código**
- 📚 **Contribuição na wiki**
- 💬 **Ajuda no fórum**

---

## 📄 **Licença**

Este projeto está licenciado sob **MIT License** - uso livre, comercial e não comercial, com obrigação de manter o copyright.

---

## 👥 **Créditos e Colaboradores**

### 👨‍💻 **Equipe Principal**
- **Wallace L Oliveira** - Desenvolvedor e arquiteto
- **Edmar Frazão** - Especialista em Reforma Tributária
- **Carlos Oliveira** - Apoiador e contribuidor

### 🏢 **Baseado Em**
- 📜 **Documentação Oficial Receita Federal**
- 🔧 **Projeto ACBr** (http://www.projetoacbr.com.br)
- 📋 **Notas Técnicas SEFAZ**
- 🎯 **Manual UB05-UB10**

---

## 📞 **Contato e Suporte**

### 📧 **Canais Oficiais**
- **Email**: contato@nuvemtributaria.com.br
- **Site**: https://nuvemtributaria.com.br
- **GitHub**: Issues do repositório
- **Discord**: Servidor da comunidade

### ⚡ **Suporte Rápido**
```delphi
// Tempo médio de resposta:
// 📧 Email: Até 48h
// 💬 Fórum: Até 24h
// 🐛 Bugs críticos: Imediato
```

---

## 🚀 **Roadmap Futuro**

### 📅 **Cronograma de Implementação**
- ✅ **2025**: IBS e CBS (implementado)
- ⏳ **2026**: Vigência oficial
- 📅 **2027**: Imposto Seletivo
- 🔮 **Pós-2027**: Adequações e melhorias

### 🎯 **Próximas Funcionalidades**
- 🔥 **Integração com ERPs**
- 📊 **Relatórios gerenciais**
- 🧪 **Mais cenários de teste**
- 📱 **App mobile de consulta**
- 🌐 **API REST**

---

**🎉 Componente 100% funcional, testado e pronto para produção!**

---

**"A união da expertise técnica com o apoio da comunidade torna possível a modernização tributária do Brasil."**

Made with ❤️ por desenvolvedores, para desenvolvedores brasileiros