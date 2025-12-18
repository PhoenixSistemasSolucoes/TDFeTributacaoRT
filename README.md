# TDFeTributacaoRT - Componente para Reforma Tributária

## Descrição

O **TDFeTributacaoRT** é um componente Delphi desenvolvido para implementar os cálculos da Reforma Tributária brasileira, incluindo o Imposto sobre Bens e Serviços (IBS), a Contribuição sobre Bens e Serviços (CBS) e o Imposto Seletivo (IS). Este componente foi projetado para trabalhar integrado com o componente ACBrNFe, facilitando a implementação das novas regras tributárias que entrarão em vigor em 2026.

## Características Principais

### 🎯 Design Pattern
- **Padrão FLUENT**: Implementa API fluente para encadeamento de métodos
- **Singleton**: Utiliza padrão Singleton para gerenciamento de instância
- **Interface Amigável**: Métodos estáticos que retornam Self para facilitar o uso

### 📊 Funcionalidades Implementadas
- Cálculo de IBS (Imposto sobre Bens e Serviços)
  - IBS Estadual (IBS UF)
  - IBS Municipal (IBS Mun)
- Cálculo de CBS (Contribuição sobre Bens e Serviços)
- Cálculo de Imposto Seletivo (IS)
- Tributação Regular
- Compra Governamental
- Crédito Presumido
- Transferência de Crédito
- Totalização automática dos valores na NF-e

### 🔧 Integração
- Compatibilidade total com **ACBrNFe**
- Suporte para todas as versões do Delphi (a partir do XE7)
- Preenchimento automático dos grupos da Reforma Tributária no XML da NF-e

## Estrutura do Projeto

```
TDFeTributacaoRT/
├── DFeTributacaoRT.pas           # Unidade principal do componente
├── Demo RT/                      # Projeto de demonstração
│   ├── ACBrNFe_Exemplo.dpr       # Aplicação demo
│   ├── Frm_ACBrNFe.pas/.dfm      # Formulário principal
│   ├── Frm_SelecionarCertificado.pas/.dfm
│   ├── Frm_ConfiguraSerial.pas/.dfm
│   ├── Frm_Status.pas/.dfm
│   └── Report/                   # Relatórios DANFE
│       ├── NFe/                  # Relatórios para NF-e
│       ├── NFCe/                 # Relatórios para NFC-e
│       └── Obsoletos/            # Relatórios antigos
├── Manuais e Notas Tecnicas/     # Documentação técnica
│   ├── NT_2025.002_v1.xx_RTC_NF-e_IBS_CBS_IS.pdf
│   ├── NT-RT_2024.002 - NF-e e NFC-e v1.00.pdf
│   └── Outras notas técnicas...
└── outros materiais/             # Materiais de apoio
    ├── CST_cClassTrib_2025-10-03_Public_verde.xlsx
    ├── Anexos por NCM e NBS 2.xlsx
    └── Comunicados oficiais...
```

## Instalação e Configuração

### Pré-requisitos
- Delphi XE7 ou superior
- Componentes ACBr (ACBrNFe, ACBrNFe.Classes, ACBrDFe.Conversao)
- Windows (plataforma suportada)

### Passos para Instalação

1. **Adicionar ao Path do Delphi**
   - Adicione a pasta do componente ao path do Delphi em: `Tools > Options > Delphi Options > Library`

2. **Compilar o Componente**
   ```delphi
   // Adicione a unidade ao seu projeto
   uses DFeTributacaoRT;
   ```

3. **Configurar ACBrNFe**
   - Certifique-se de ter o ACBrNFe devidamente configurado em seu projeto

## Como Usar

### Exemplo Básico de Uso

```delphi
// Exemplo básico de configuração para um item da NF-e
procedure ConfigurarReformaTributaria;
begin
  // Configura o componente usando padrão FLUENT
  TDFeTributacaoRT
    .ACBr(ACBrNFe1)                    // Componente ACBr
    .CST('000')                        // CST do item
    .ClassTrib('000001')               // Classificação tributária
    .AliquotaIBSUF(25.00)             // Alíquota de IBS Estadual
    .AliquotaIBSMun(10.00)            // Alíquota de IBS Municipal
    .AliquotaCBS(10.00)               // Alíquota de CBS
    .Reducao(5.00)                    // Redução na base (opcional)
    .Calcular;                        // Executa o cálculo
end;
```

### Exemplo com Imposto Seletivo

```delphi
// Configurando item com Imposto Seletivo (a partir de 2027)
procedure ConfigurarComImpostoSeletivo;
begin
  TDFeTributacaoRT
    .ACBr(ACBrNFe1)
    .CST('000')
    .AliquotaIBSUF(25.00)
    .AliquotaCBS(10.00)
    .ImpostoSeletivo(
      1000.00,  // Base de cálculo do IS
      15.00,    // Alíquota do IS
      0,        // Alíquota específica
      'UN',     // Unidade tributável
      1         // Quantidade tributável
    )
    .Calcular;
end;
```

### Exemplo Completo com Todos os Grupos

```delphi
procedure ConfigurarCompleto;
begin
  TDFeTributacaoRT
    // Configuração básica
    .ACBr(ACBrNFe1)
    .CST('000')
    .ClassTrib('000001')
    .IndicadorDoacao(tieNenhum)
    .AliquotaIBSUF(25.00)
    .AliquotaIBSMun(10.00)
    .AliquotaCBS(10.00)

    // Tributação Regular
    .TributacaoRegular(
      cstRegNenhum,    // CST Regular
      '000001',        // Classificação tributária regular
      0, 0, 0, 0, 0, 0 // Valores efetivos (preenchidos conforme necessidade)
    )

    // Crédito Presumido
    .CreditoPresumido(
      cpNenhum,        // Código do crédito presumido
      0,               // Base do crédito presumido
      0,               // Alíquota de IBS
      0,               // Valor do crédito
      0,               // Alíquota de CBS
      0                // Valor do crédito CBS
    )

    // Transferência de Crédito
    .TransferenciaCredito(100.00, 50.00) // IBS, CBS

    // Executar cálculo e totalização
    .Calcular
    .CalcularTotalizacao;
end;
```

## Referência da API

### Métodos Principais

#### Configuração Básica
- `ACBr(TACBrNFe)`: Define o componente ACBrNFe a ser utilizado
- `CST(string)`: Define o CST do item
- `ClassTrib(string)`: Define a classificação tributária
- `IndicadorDoacao(TIndicadorEx)`: Indicador de doação

#### Alíquotas
- `AliquotaIBSUF(Double)`: Alíquota de IBS Estadual (%)
- `AliquotaIBSMun(Double)`: Alíquota de IBS Municipal (%)
- `AliquotaCBS(Double)`: Alíquota de CBS (%)
- `Reducao(Double)`: Redução na base de cálculo (%)

#### Grupos Especiais
- `ImpostoSeletivo(vBC, pIS, pISEspec: Double; uTrib: string; qTrib: Double)`: Configura Imposto Seletivo
- `TributacaoRegular(...)`: Configura tributação regular
- `CreditoPresumido(...)`: Configura crédito presumido
- `TransferenciaCredito(vIBS, vCBS: Double)`: Configura transferência de crédito

#### Cálculo
- `Calcular`: Executa os cálculos para o item atual
- `CalcularTotalizacao`: Calcula totais da NF-e

### Propriedades de Leitura

Após o cálculo, você pode acessar os valores calculados através das propriedades:

- `vTotalIS`: Valor total do Imposto Seletivo
- `vTotalBCIBSCBS`: Base de cálculo total de IBS/CBS
- `vTotalIBS`: Valor total de IBS
- `vTotalIBSUF`: Valor total de IBS Estadual
- `vTotalIBSMun`: Valor total de IBS Municipal
- `vTotalCBS`: Valor total de CBS
- `vTotalNFTot`: Valor total da NF-e com reforma tributária

## Documentação de Referência

O projeto inclui uma vasta documentação técnica na pasta `Manuais e Notas Tecnicas/`:

- **NT_2025.002_v1.xx**: Nota técnica sobre implementação da RTC na NF-e
- **NT-RT_2024.002**: Primeira versão das regras de IBS/CBS/IS
- **CST_cClassTrib_2025-10-03.xlsx**: Tabela completa de CST e classificações tributárias
- **Anexos por NCM e NBS 2.xlsx**: Detalhamento por NCM e NBS

## Importante Sobre a Reforma Tributária

### Cronograma de Implementação
- **2026**: Início da vigência do IBS e CBS
- **2027**: Início da vigência do Imposto Seletivo
- **Transição**: Período de adaptação com regras específicas

### Validações Automáticas
O componente realiza validações importantes:
- Impede cálculo para CST que não devem gerar IBS/CBS (040, 041, 050, 051, 400, 410, 500)
- Aplica Imposto Seletivo apenas a partir de 2027
- Garante valores não negativos nos cálculos
- Arredonda valores para 2 casas decimais

## Demo Interativo

O projeto inclui uma aplicação demo completa em `Demo RT/ACBrNFe_Exemplo.dpr` que demonstra:

- Configuração de certificado digital
- Emissão de NF-e com os novos campos
- Visualização dos cálculos em tempo real
- Geração de DANFE com as novas informações
- Exemplos práticos de todas as funcionalidades

## Suporte e Contribuições

### Como Contribuir
1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Implemente as mudanças
4. Envie um pull request

### Reportar Problemas
- Abra uma issue descrevendo o problema
- Inclua detalhes do ambiente (versão do Delphi, Windows)
- Anexe exemplo de código se aplicável

### Doações via PIX

Se você encontrar este componente útil e desejar apoiar o desenvolvimento, faça uma doação:

**CNPJ:** 28.254.501/0001-13
**Nome:** Wallace L Oliveira
**Chave PIX:** Use o CNPJ acima como chave

---

## Licença

Este projeto está licenciado sob os mesmos termos dos componentes ACBr (LGPL/LGPLR).

## Créditos

- Desenvolvido por Wallace L Oliveira
- Baseado na documentação oficial da Receita Federal
- Integrado com o projeto ACBr (Projeto ACBr - http://www.sourceforge.net/projects/acbr)

---

**Aviso:** Este componente está em desenvolvimento contínuo para acompanhar as atualizações da legislação da Reforma Tributária. Mantenha-se atualizado com as últimas versões.