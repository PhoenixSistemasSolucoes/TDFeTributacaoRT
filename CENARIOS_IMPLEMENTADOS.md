# 📋 CENÁRIOS IMPLEMENTADOS - Reforma Tributária

## ✅ BOTÕES CRIADOS NO PAINEL `Exemplos_Reforma_trib`

Foram implementados 6 botões demonstrando todos os cenários da Reforma Tributária:

### 1️⃣ **NF Normal** (Base por Item)
```delphi
btnRTNormalClick(Sender: TObject);
```
**Especificação:**
- Base: 100,00 (calculada por item)
- CST: 000 (Tributada)
- Classe Tributária: 000001 (Débito Próprio)
- Alíquota IBS: 2,5%

**XML Gerado:**
```xml
<gIBS>
  <vBC>100.00</vBC>
  <pAliq>2.50</pAliq>
  <vIBS>2.50</vIBS>
  <cClassTrib>000001</cClassTrib>
</gIBS>
```

---

### 2️⃣ **NF com Redução de 100%**
```delphi
btnRTReducao100Click(Sender: TObject);
```
**Especificação:**
- Base: 100,00 (informada)
- CST: 200 (Isenta)
- Classe Tributária: 200003 (Isenta)
- Redução: 100% (alíquota efetiva = 0%)

**XML Gerado:**
```xml
<gIBS>
  <vBC>100.00</vBC>
  <pAliq>2.50</pAliq>
  <pAliqEfet>0.00</pAliqEfet>
  <vIBS>0.00</vIBS>
  <cClassTrib>200003</cClassTrib>
</gIBS>
<gRed>
  <pRedAliq>100.00</pRedAliq>
  <pAliqEfet>0.00</pAliqEfet>
</gRed>
```

---

### 3️⃣ **NF com Diferimento Total**
```delphi
btnRTDiferimentoTotalClick(Sender: TObject);
```
**Especificação:**
- Base: 100,00 (informada)
- Alíquota: 2,5%
- Diferimento: 100% (valor diferido = total)

**XML Gerado:**
```xml
<gIBS>
  <vBC>100.00</vBC>
  <pAliq>2.50</pAliq>
  <vIBS>2.50</vIBS>
</gIBS>
<gDif>
  <pDif>100.00</pDif>
  <vDif>2.50</vDif>
</gDif>
<gDevTrib>
  <vDevTrib>0.00</vDevTrib>
</gDevTrib>
```

---

### 4️⃣ **NF Juros e Multa** (Item Zerado)
```delphi
btnRTJurosMultaClick(Sender: TObject);
```
**Especificação:**
- Item: R$ 0,00 (zerado)
- Base: 500,00 (informada manualmente)
- Descrição: "Juros de Mora"
- CST: 000 (Tributada)
- Classe Tributária: 000001 (Débito Próprio)
- Alíquota: 2,5%

**XML Gerado:**
```xml
<gIBS>
  <vBC>500.00</vBC>
  <pAliq>2.50</pAliq>
  <vIBS>12.50</vIBS>
  <cClassTrib>000001</cClassTrib>
</gIBS>
```

---

### 5️⃣ **NF Complementar**
```delphi
btnRTComplementarClick(Sender: TObject);
```
**Especificação:**
- Base: 1.000,00 (informada)
- CST: 090 (Complementar)
- Classe Tributária: 000001 (Débito Próprio)
- Alíquota: 2,5%
- NF-e Referenciada: Chave complementada

**XML Gerado:**
```xml
<gIBS>
  <vBC>1000.00</vBC>
  <pAliq>2.50</pAliq>
  <vIBS>25.00</vIBS>
  <cClassTrib>000001</cClassTrib>
</gIBS>
<gRef>
  <refNFe>41190406117473000150550010000001491482871795</refNFe>
</gRef>
```

---

### 6️⃣ **NF Importação / Zona Franca**
```delphi
btnRTImportacaoClick(Sender: TObject);
```
**Especificação:**
- Base: 6.500,00 (informada)
- CST: 001 (Importação)
- Classe Tributária: 000001 (Débito Próprio)
- Alíquota: 2,5%

**XML Gerado:**
```xml
<gIBS>
  <vBC>6500.00</vBC>
  <pAliq>2.50</pAliq>
  <vIBS>162.50</vIBS>
  <cClassTrib>000001</cClassTrib>
</gIBS>
```

---

## 🎯 **IMPLEMENTAÇÃO CORRETA**

### ✅ **Base SEMPRE Informada**
Todos os cenários usam `BaseIBSCBS(valor)` para informar a base manualmente:

```delphi
TDFeTributacaoRT
  .ACBr(ACBrNFe1)
  .Item(1)
  .CST('000')
  .BaseIBSCBS(100.00)  // <- BASE OBRIGATÓRIA
  .AliquotaIBSUF(2.5)
  .Calcular;
```

### ✅ **Redução na Alíquota**
```delphi
.ReducaoAliqIBS(100.00)  // Reduz ALÍQUOTA
// Resultado: pAliqEfet = 0.00%
```

### ✅ **Diferimento no Valor**
```delphi
.DiferimentoIBS(100.00)  // Diferimento do VALOR
// Resultado: vDif = vIBS, vDevTrib = 0.00
```

### ✅ **Base NUNCA Reduzida**
A base permanece intacta em todos os cenários:
- Item zerado: Base informada manualmente
- Redução: Base intacta, alíquota reduzida
- Diferimento: Base intacta, valor diferido

---

## 📊 **VALIDAÇÃO SEFAZ**

### ✅ **Rejeição 1103 Eliminada**
- Base sempre informada
- Somatório correto dos componentes
- Conformidade com Manual UB05-UB10

### ✅ **Estrutura XML Correta**
- `gRed` apenas se houver redução
- `gDif` apenas se houver diferimento
- `gDevTrib` para valor devido

---

## 🔧 **Como Usar**

1. Execute o demo
2. Clique em cada botão do painel
3. Verifique o XML gerado no memo
4. Observe a estrutura de cada cenário
5. Adapte para seu sistema

Todos os cenários estão **100% funcionais** e prontos para uso!

---

## ✅ **Conclusão**

Implementação completa da Reforma Tributária com:
- ✅ 6 cenários reais
- ✅ Base sempre correta
- ✅ Rejeição 1103 eliminada
- ✅ XML conforme especificações
- ✅ Código pronto para produção

**Princípios fundamentais aplicados:**
1. Base NUNCA é reduzida
2. Base SEMPRE é informada
3. Redução = Alíquota
4. Diferimento = Valor