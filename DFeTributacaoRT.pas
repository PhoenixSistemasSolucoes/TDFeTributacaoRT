unit DFeTributacaoRT;

interface

uses
  SysUtils, Classes, DateUtils, Math,
  ACBrNFe, ACBrNFe.Classes, ACBrDFe.Conversao;

type
  // Classe para cálculo da Reforma Tributária (IBS, CBS e IS)
  // Implementa padrão FLUENT (encadeado) para facilitar uso no Demo ACBr
  // Responsável por preencher TODOS os grupos da Reforma Tributária
  TDFeTributacaoRT = class
  private
    FACBr: TACBrNFe;
    FCST: string;
    FClassTrib: string;
    FindicadorDoacao: TIndicadorEx;
    FAliquotaIBSUF: Double;
    FAliquotaIBSMun: Double;
    FAliquotaCBS: Double;

    // Parâmetros de cálculo corrigidos
    FBaseIBSCBS: Double;
    FpRedAliqIBS: Double; // Percentual de REDUÇÃO DE ALÍQUOTA (não da base!)
    FpDifIBS: Double; // Percentual de DIFERIMENTO (após cálculo do imposto)
    FpRedAliqCBS: Double;
    FpDifCBS: Double;

    // Imposto Seletivo
    FvBCIS: Double;
    FpIS: Double;
    FpISEspec: Double;
    FuTrib: string;
    FqTrib: Double;
    FvIS: Double;

    // Tributação Regular
    FCSTReg: TCSTIBSCBS;
    FcClassTribReg: string;
    FpAliqEfetRegIBSUF: Double;
    FvTribRegIBSUF: Double;
    FpAliqEfetRegIBSMun: Double;
    FvTribRegIBSMun: Double;
    FpAliqEfetRegCBS: Double;
    FvTribRegCBS: Double;

    // Compra Governamental
    FpAliqIBSUF: Double;
    FvTribIBSUF: Double;
    FpAliqIBSMun: Double;
    FvTribIBSMun: Double;
    FpAliqCBS: Double;
    FvTribCBS: Double;

    // Crédito Presumido
    FcCredPres: TcCredPres;
    FvBCCredPres: Double;
    FpCredPresIBS: Double;
    FvCredPres: Double;
    FvCredPresCondSus: Double;
    FpCredPresCBS: Double;
    FvCredPresCBS: Double;
    FvCredPresCBSCondSus: Double;

    // Transferência de Crédito
    FvTransfIBS: Double;
    FvTransfCBS: Double;

    // Propriedades de Totalização
    FvTotalIS: Double;
    FvTotalBCIBSCBS: Double;
    FvTotalIBS: Double;
    FvTotalIBSUF: Double;
    FvTotalIBSMun: Double;
    FvTotalCBS: Double;
    FvTotalNFTot: Double;

    // Instância Singleton
    class var FInstance: TDFeTributacaoRT;

    // Construtor privado para Singleton
    constructor CreateInstance;

    // Método privado para obter o item atual da NF-e
    function ObterItemAtual: TDetCollectionItem;

    // Método privado para calcular totais de todos os itens
    procedure CalcularTotais;

    // Função para cálculo correto da base de IBS/CBS
  public
    class function BaseCBSIBS(const vProd, vServ, vFrete, vSeg, vOutro, vII, vDesc,
                              vPIS, vCOFINS, vICMS, vICMSUFDest, vFCP, vFCPUFDest,
                              vICMSMono, vISSQN: Double): Double; overload;

    // Função simplificada - apenas retorna a base informada (OBRIGATÓRIO)
    class function BaseCBSIBS(const ABaseInformada: Double): Double; overload;

    // Função para cálculo do imposto com redução de alíquota e diferimento
    class function CalcularImpostoRT(const BaseCalculo, pAliq, pRedAliq, pDif: Double;
                                    var vImposto, vDiferimento: Double): Double;

  public
    constructor Create; deprecated 'Use class methods instead';
    destructor Destroy; override;

    // Métodos de classe para Singleton
    class function Instance: TDFeTributacaoRT;
    class procedure ReleaseInstance;

    // API FLUENT estática - Métodos que retornam Self para encadeamento
    class function ACBr(const Value: TACBrNFe): TDFeTributacaoRT;
    class function CST(const Value: string): TDFeTributacaoRT;
    class function ClassTrib(const Value: string): TDFeTributacaoRT;
    class function IndicadorDoacao(Value: TIndicadorEx): TDFeTributacaoRT;
    class function AliquotaIBSUF(Value: Double): TDFeTributacaoRT;
    class function AliquotaIBSMun(Value: Double): TDFeTributacaoRT;
    class function AliquotaCBS(Value: Double): TDFeTributacaoRT;

    // Novos métodos paramétricos CORRIGIDOS
    class function BaseIBSCBS(Value: Double): TDFeTributacaoRT; // Base livre informada
    class function ReducaoAliqIBS(Value: Double): TDFeTributacaoRT; // Redução de ALÍQUOTA IBS
    class function DiferimentoIBS(Value: Double): TDFeTributacaoRT; // Diferimento IBS
    class function ReducaoAliqCBS(Value: Double): TDFeTributacaoRT; // Redução de ALÍQUOTA CBS
    class function DiferimentoCBS(Value: Double): TDFeTributacaoRT; // Diferimento CBS

    // Método para cálculo automático da base (apenas quando solicitado)
    class function CalcularBaseDoItem: TDFeTributacaoRT;

    // Manter compatibilidade com método antigo (deprecated)
    class function Reducao(Value: Double): TDFeTributacaoRT; deprecated 'Use ReducaoAliqIBS ou ReducaoAliqCBS';

    // Métodos para Imposto Seletivo
    class function ImpostoSeletivo(vBC, pIS, pISEspec: Double; uTrib: string; qTrib: Double): TDFeTributacaoRT;

    // Métodos para Tributação Regular
    class function TributacaoRegular(CSTReg: TCSTIBSCBS; cClassTribReg: string;
      pAliqEfetRegIBSUF, vTribRegIBSUF, pAliqEfetRegIBSMun, vTribRegIBSMun,
      pAliqEfetRegCBS, vTribRegCBS: Double): TDFeTributacaoRT;

    // Métodos para Compra Governamental
    class function CompraGovernamental(pAliqIBSUF, vTribIBSUF, pAliqIBSMun, vTribIBSMun,
      pAliqCBS, vTribCBS: Double): TDFeTributacaoRT;

    // Métodos para Crédito Presumido
    class function CreditoPresumido(cCredPres: TcCredPres; vBCCredPres, pCredPresIBS,
      vCredPres, pCredPresCBS, vCredPresCBS: Double): TDFeTributacaoRT;

    // Métodos para Transferência de Crédito
    class function TransferenciaCredito(vIBS, vCBS: Double): TDFeTributacaoRT;

    class function Calcular: TDFeTributacaoRT; // Também retorna Self para manter fluência

    // Método para totalização da NF-e
    class function CalcularTotalizacao: TDFeTributacaoRT;

    // Propriedades de resultado (somente leitura)
    property IBSUFTotal: Double read FAliquotaIBSUF;
    property IBSMunTotal: Double read FAliquotaIBSMun;
    property CBSTotal: Double read FAliquotaCBS;

    // Propriedades de totalização (somente leitura)
    property vTotalIS: Double read FvTotalIS;
    property vTotalBCIBSCBS: Double read FvTotalBCIBSCBS;
    property vTotalIBS: Double read FvTotalIBS;
    property vTotalIBSUF: Double read FvTotalIBSUF;
    property vTotalIBSMun: Double read FvTotalIBSMun;
    property vTotalCBS: Double read FvTotalCBS;
    property vTotalNFTot: Double read FvTotalNFTot;
  end;

implementation

{ TDFeTributacaoRT }

class function TDFeTributacaoRT.Instance: TDFeTributacaoRT;
begin
  if not Assigned(FInstance) then
    FInstance := TDFeTributacaoRT.CreateInstance;
  Result := FInstance;
end;

class procedure TDFeTributacaoRT.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

constructor TDFeTributacaoRT.CreateInstance;
begin
  inherited Create;
  // Valores padrão
  FCST := '000';
  FClassTrib := '000001';
  FindicadorDoacao := tieNenhum;
  FAliquotaIBSUF := 0;
  FAliquotaIBSMun := 0;
  FAliquotaCBS := 0;

  // Novos parâmetros corretos
  FBaseIBSCBS := 0; // Base DEVE ser informada
  FpRedAliqIBS := 0;
  FpDifIBS := 0;
  FpRedAliqCBS := 0;
  FpDifCBS := 0;

  // Imposto Seletivo
  FvBCIS := 0;
  FpIS := 0;
  FpISEspec := 0;
  FuTrib := 'UN';
  FqTrib := 0;
  FvIS := 0;

  // Tributação Regular
  FCSTReg := cstNenhum;
  FcClassTribReg := '';
  FpAliqEfetRegIBSUF := 0;
  FvTribRegIBSUF := 0;
  FpAliqEfetRegIBSMun := 0;
  FvTribRegIBSMun := 0;
  FpAliqEfetRegCBS := 0;
  FvTribRegCBS := 0;

  // Compra Governamental
  FpAliqIBSUF := 0;
  FvTribIBSUF := 0;
  FpAliqIBSMun := 0;
  FvTribIBSMun := 0;
  FpAliqCBS := 0;
  FvTribCBS := 0;

  // Crédito Presumido
  FcCredPres := cpNenhum;
  FvBCCredPres := 0;
  FpCredPresIBS := 0;
  FvCredPres := 0;
  FvCredPresCondSus := 0;
  FpCredPresCBS := 0;
  FvCredPresCBS := 0;
  FvCredPresCBSCondSus := 0;

  // Transferência de Crédito
  FvTransfIBS := 0;
  FvTransfCBS := 0;

  // Totalização
  FvTotalIS := 0;
  FvTotalBCIBSCBS := 0;
  FvTotalIBS := 0;
  FvTotalIBSUF := 0;
  FvTotalIBSMun := 0;
  FvTotalCBS := 0;
  FvTotalNFTot := 0;
end;

constructor TDFeTributacaoRT.Create;
begin
  raise Exception.Create('Use class methods instead of Create. Example: TDFeTributacaoRT.ACBr(ACBrNFe1).CST(...)');
end;

destructor TDFeTributacaoRT.Destroy;
begin
  FACBr := nil; // Não destruir o componente ACBr, apenas remover referência
  inherited Destroy;
end;

class function TDFeTributacaoRT.ACBr(const Value: TACBrNFe): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FACBr := Value;
end;

class function TDFeTributacaoRT.CST(const Value: string): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FCST := Value;
end;

class function TDFeTributacaoRT.ClassTrib(const Value: string): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FClassTrib := Value;
end;

class function TDFeTributacaoRT.IndicadorDoacao(Value: TIndicadorEx): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FindicadorDoacao := Value;
end;

class function TDFeTributacaoRT.AliquotaIBSUF(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FAliquotaIBSUF := Value;
end;

class function TDFeTributacaoRT.AliquotaIBSMun(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FAliquotaIBSMun := Value;
end;

class function TDFeTributacaoRT.AliquotaCBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FAliquotaCBS := Value;
end;

class function TDFeTributacaoRT.BaseIBSCBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FBaseIBSCBS := Value;
end;

class function TDFeTributacaoRT.ReducaoAliqIBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FpRedAliqIBS := Value;
end;

class function TDFeTributacaoRT.DiferimentoIBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FpDifIBS := Value;
end;

class function TDFeTributacaoRT.ReducaoAliqCBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FpRedAliqCBS := Value;
end;

class function TDFeTributacaoRT.DiferimentoCBS(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FpDifCBS := Value;
end;

class function TDFeTributacaoRT.CalcularBaseDoItem: TDFeTributacaoRT;
var
  Item: TDetCollectionItem;
begin
  Result := Instance;

  // Obter o item atual
  Item := Result.ObterItemAtual;

  // Calcular base padrão do item (conforme manual UB05-UB10)
  Result.FBaseIBSCBS := Result.BaseCBSIBS(
    Item.Prod.vProd,           // vProd
    0,                         // vServ (geralmente zero em produtos)
    Item.Prod.vFrete,          // vFrete
    Item.Prod.vSeg,            // vSeg
    Item.Prod.vOutro,          // vOutro
    0,                         // vII (imposto de importação)
    Item.Prod.vDesc,           // vDesc
    0,                         // vPIS
    0,                         // vCOFINS
    0,                         // vICMS
    0,                         // vICMSUFDest
    0,                         // vFCP
    0,                         // vFCPUFDest
    0,                         // vICMSMono
    0                          // vISSQN
  );
end;

// Manter compatibilidade
class function TDFeTributacaoRT.Reducao(Value: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  // Assume que é redução de IBS para compatibilidade
  Result.FpRedAliqIBS := Value;
end;

class function TDFeTributacaoRT.ImpostoSeletivo(vBC, pIS, pISEspec: Double; uTrib: string; qTrib: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FvBCIS := vBC;
  Result.FpIS := pIS;
  Result.FpISEspec := pISEspec;
  Result.FuTrib := uTrib;
  Result.FqTrib := qTrib;
  Result.FvIS := vBC * (pIS / 100);
end;

class function TDFeTributacaoRT.TributacaoRegular(CSTReg: TCSTIBSCBS; cClassTribReg: string;
  pAliqEfetRegIBSUF, vTribRegIBSUF, pAliqEfetRegIBSMun, vTribRegIBSMun,
  pAliqEfetRegCBS, vTribRegCBS: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FCSTReg := CSTReg;
  Result.FcClassTribReg := cClassTribReg;
  Result.FpAliqEfetRegIBSUF := pAliqEfetRegIBSUF;
  Result.FvTribRegIBSUF := vTribRegIBSUF;
  Result.FpAliqEfetRegIBSMun := pAliqEfetRegIBSMun;
  Result.FvTribRegIBSMun := vTribRegIBSMun;
  Result.FpAliqEfetRegCBS := pAliqEfetRegCBS;
  Result.FvTribRegCBS := vTribRegCBS;
end;

class function TDFeTributacaoRT.CompraGovernamental(pAliqIBSUF, vTribIBSUF, pAliqIBSMun, vTribIBSMun,
  pAliqCBS, vTribCBS: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FpAliqIBSUF := pAliqIBSUF;
  Result.FvTribIBSUF := vTribIBSUF;
  Result.FpAliqIBSMun := pAliqIBSMun;
  Result.FvTribIBSMun := vTribIBSMun;
  Result.FpAliqCBS := pAliqCBS;
  Result.FvTribCBS := vTribCBS;
end;

class function TDFeTributacaoRT.CreditoPresumido(cCredPres: TcCredPres; vBCCredPres, pCredPresIBS,
  vCredPres, pCredPresCBS, vCredPresCBS: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FcCredPres := cCredPres;
  Result.FvBCCredPres := vBCCredPres;
  Result.FpCredPresIBS := pCredPresIBS;
  Result.FvCredPres := vCredPres;
  Result.FpCredPresCBS := pCredPresCBS;
  Result.FvCredPresCBS := vCredPresCBS;
end;

class function TDFeTributacaoRT.TransferenciaCredito(vIBS, vCBS: Double): TDFeTributacaoRT;
begin
  Result := Instance;
  Result.FvTransfIBS := vIBS;
  Result.FvTransfCBS := vCBS;
end;

function TDFeTributacaoRT.ObterItemAtual: TDetCollectionItem;
begin
  Result := nil;

  // Validações
  if not Assigned(FACBr) then
    raise Exception.Create('Componente ACBrNFe não foi atribuído. Use o método .ACBr() primeiro.');

  if FACBr.NotasFiscais.Count = 0 then
    raise Exception.Create('Nenhuma NF-e carregada no componente ACBr.');

  if FACBr.NotasFiscais.Items[0].NFe.Det.Count = 0 then
    raise Exception.Create('Nenhum item encontrado na NF-e.');

  // SEMPRE trabalhar com o ÚLTIMO item (conforme regra especificada)
  Result := FACBr.NotasFiscais.Items[0].NFe.Det.Items[FACBr.NotasFiscais.Items[0].NFe.Det.Count - 1];
end;

class function TDFeTributacaoRT.BaseCBSIBS(const vProd, vServ, vFrete, vSeg, vOutro, vII, vDesc,
                                          vPIS, vCOFINS, vICMS, vICMSUFDest, vFCP, vFCPUFDest,
                                          vICMSMono, vISSQN: Double): Double;
begin
  // Cálculo da base de IBS/CBS conforme manual (UB05-UB10)
  // vBC = vProd + vServ + vFrete + vSeg + vOutro + vII - vDesc - vPIS - vCOFINS
  //       - vICMS - vICMSUFDest - vFCP - vFCPUFDest - vICMSMono - vISSQN

  Result := vProd + vServ + vFrete + vSeg + vOutro + vII - vDesc
           - vPIS - vCOFINS - vICMS - vICMSUFDest - vFCP - vFCPUFDest
           - vICMSMono - vISSQN;

  // Garantir valor não negativo
  if Result < 0 then
    Result := 0;
end;

class function TDFeTributacaoRT.BaseCBSIBS(const ABaseInformada: Double): Double;
begin
  // Função OBRIGATÓRIA - apenas retorna a base informada
  // NÃO aplica redução
  // NÃO aplica diferimento
  // NÃO acessa valores do item
  // Base permanece EXATAMENTE como foi informada

  Result := ABaseInformada;

  // Garantir valor não negativo
  if Result < 0 then
    Result := 0;
end;

class function TDFeTributacaoRT.CalcularImpostoRT(const BaseCalculo, pAliq, pRedAliq, pDif: Double;
                                                  var vImposto, vDiferimento: Double): Double;
var
  pAliqEfetiva: Double;
begin
  // Passo 1: Calcular alíquota efetiva após redução
  if pRedAliq > 0 then
    pAliqEfetiva := pAliq * (1 - pRedAliq / 100)
  else
    pAliqEfetiva := pAliq;

  // Passo 2: Calcular valor do imposto com alíquota efetiva
  vImposto := BaseCalculo * pAliqEfetiva / 100;

  // Passo 3: Aplicar diferimento
  if pDif > 0 then
  begin
    vDiferimento := vImposto * pDif / 100;
    Result := vImposto - vDiferimento;
  end
  else
  begin
    vDiferimento := 0;
    Result := vImposto;
  end;

  // Arredondar valores
  vImposto := RoundTo(vImposto, -2);
  vDiferimento := RoundTo(vDiferimento, -2);
  Result := RoundTo(Result, -2);
end;

class function TDFeTributacaoRT.Calcular: TDFeTributacaoRT;
var
  Item: TDetCollectionItem;
  vIBSUF, vIBSMun, vCBS, vIBSUFFull, vIBSMunFull, vCBSFull: Double;
  vDifIBSUF, vDifIBSMun, vDifCBS: Double;
  vCalculoIBS, vCalculoCBS: Double;
  BaseCalculo: Double;
  AnoEmissao: Integer;
begin
  Result := Instance;

  // Validar componente ACBr
  if not Assigned(Result.FACBr) then
    raise Exception.Create('Componente ACBrNFe não foi atribuído');

  // Obter o item atual
  Item := Result.ObterItemAtual;

  // Validar CST
  if (Result.FCST = '040') or (Result.FCST = '041') or (Result.FCST = '050') or (Result.FCST = '051') or
     (Result.FCST = '400') or (Result.FCST = '410') or (Result.FCST = '500') then
    raise Exception.Create('CST ' + Result.FCST + ' não deve gerar IBS/CBS');

  // VALIDAÇÃO OBRIGATÓRIA: Base DEVE ser informada
  if Result.FBaseIBSCBS = 0 then
    raise Exception.Create('Base de cálculo IBS/CBS não foi informada. Use .BaseIBSCBS(valor) ou .CalcularBaseDoItem()');

  // Usar base informada (NÃO calcula automaticamente!)
  BaseCalculo := Result.FBaseIBSCBS;

  // Calcular IBS UF com redução e diferimento
  if Result.FAliquotaIBSUF > 0 then
  begin
    vCalculoIBS := Result.CalcularImpostoRT(BaseCalculo, Result.FAliquotaIBSUF,
                                            Result.FpRedAliqIBS, Result.FpDifIBS,
                                            vIBSUFFull, vDifIBSUF);
    vIBSUF := vCalculoIBS;
  end
  else
  begin
    vIBSUF := 0;
    vDifIBSUF := 0;
    vIBSUFFull := 0;
  end;

  // Calcular IBS Municipal com redução e diferimento
  if Result.FAliquotaIBSMun > 0 then
  begin
    vCalculoIBS := Result.CalcularImpostoRT(BaseCalculo, Result.FAliquotaIBSMun,
                                            Result.FpRedAliqIBS, Result.FpDifIBS,
                                            vIBSMunFull, vDifIBSMun);
    vIBSMun := vCalculoIBS;
  end
  else
  begin
    vIBSMun := 0;
    vDifIBSMun := 0;
    vIBSMunFull := 0;
  end;

  // Calcular CBS com redução e diferimento
  if Result.FAliquotaCBS > 0 then
  begin
    vCalculoCBS := Result.CalcularImpostoRT(BaseCalculo, Result.FAliquotaCBS,
                                            Result.FpRedAliqCBS, Result.FpDifCBS,
                                            vCBSFull, vDifCBS);
    vCBS := vCalculoCBS;
  end
  else
  begin
    vCBS := 0;
    vDifCBS := 0;
    vCBSFull := 0;
  end;

  // Ano da emissão para validar aplicação das regras
  AnoEmissao := YearOf(Result.FACBr.NotasFiscais.Items[0].NFe.Ide.dEmi);

  // Criar estrutura do grupo IBSCBS se não existir
  if not Assigned(Item.Imposto.IBSCBS) then
    Item.Imposto.IBSCBS := TIBSCBS.Create;

  // Preencher dados do IBS/CBS
  with Item.Imposto.IBSCBS do
  begin
    // Dados básicos
    CST := StrToCSTIBSCBS(Result.FCST);
    cClassTrib := Result.FClassTrib;
    indDoacao := Result.FindicadorDoacao;

    // Criar grupo gIBSCBS se não existir
    if not Assigned(gIBSCBS) then
      gIBSCBS := TgIBSCBS.Create;

    // Preencher grupo de cálculo
    gIBSCBS.vBC := RoundTo(BaseCalculo, -2);

    // Preencher IBS UF com grupos CORRETOS
    if Result.FAliquotaIBSUF > 0 then
    begin
      gIBSCBS.gIBSUF.pIBSUF := Result.FAliquotaIBSUF;
      gIBSCBS.gIBSUF.vIBSUF := RoundTo(vIBSUF, -2);

      // Grupo gRed - Redução de Alíquota (SE HOUVER)
      if Result.FpRedAliqIBS > 0 then
      begin
        gIBSCBS.gIBSUF.gRed.pRedAliq := Result.FpRedAliqIBS;
        gIBSCBS.gIBSUF.gRed.pAliqEfet := Result.FAliquotaIBSUF * (1 - Result.FpRedAliqIBS / 100);
      end
      else
      begin
        gIBSCBS.gIBSUF.gRed.pRedAliq := 0;
        gIBSCBS.gIBSUF.gRed.pAliqEfet := 0;
      end;

      // Grupo gDif - Diferimento (SE HOUVER)
      if Result.FpDifIBS > 0 then
      begin
        gIBSCBS.gIBSUF.gDif.pDif := Result.FpDifIBS;
        gIBSCBS.gIBSUF.gDif.vDif := RoundTo(vDifIBSUF, -2);
        gIBSCBS.gIBSUF.gDevTrib.vDevTrib := RoundTo(vIBSUF, -2);
      end
      else
      begin
        gIBSCBS.gIBSUF.gDif.pDif := 0;
        gIBSCBS.gIBSUF.gDif.vDif := 0;
        gIBSCBS.gIBSUF.gDevTrib.vDevTrib := 0;
      end;
    end;

    // Preencher IBS Municipal com grupos CORRETOS (SEMPRE criar!)
    // MESMO que alíquota seja zero, grupo deve existir
    gIBSCBS.gIBSMun.pIBSMun := Result.FAliquotaIBSMun;
    gIBSCBS.gIBSMun.vIBSMun := RoundTo(vIBSMun, -2);

    // Grupo gRed - Redução de Alíquota (SE HOUVER)
    if Result.FpRedAliqIBS > 0 then
    begin
      gIBSCBS.gIBSMun.gRed.pRedAliq := Result.FpRedAliqIBS;
      gIBSCBS.gIBSMun.gRed.pAliqEfet := Result.FAliquotaIBSMun * (1 - Result.FpRedAliqIBS / 100);
    end
    else
    begin
      gIBSCBS.gIBSMun.gRed.pRedAliq := 0;
      gIBSCBS.gIBSMun.gRed.pAliqEfet := 0;
    end;

    // Grupo gDif - Diferimento (SE HOUVER)
    if Result.FpDifIBS > 0 then
    begin
      gIBSCBS.gIBSMun.gDif.pDif := Result.FpDifIBS;
      gIBSCBS.gIBSMun.gDif.vDif := RoundTo(vDifIBSMun, -2);
      gIBSCBS.gIBSMun.gDevTrib.vDevTrib := RoundTo(vIBSMun, -2);
    end
    else
    begin
      gIBSCBS.gIBSMun.gDif.pDif := 0;
      gIBSCBS.gIBSMun.gDif.vDif := 0;
      gIBSCBS.gIBSMun.gDevTrib.vDevTrib := 0;
    end;

    // Preencher CBS com grupos CORRETOS (SEMPRE criar!)
    // MESMO que alíquota seja zero, grupo deve existir
    gIBSCBS.gCBS.pCBS := Result.FAliquotaCBS;
    gIBSCBS.gCBS.vCBS := RoundTo(vCBS, -2);

    // Grupo gRed - Redução de Alíquota (SE HOUVER)
    if Result.FpRedAliqCBS > 0 then
    begin
      gIBSCBS.gCBS.gRed.pRedAliq := Result.FpRedAliqCBS;
      gIBSCBS.gCBS.gRed.pAliqEfet := Result.FAliquotaCBS * (1 - Result.FpRedAliqCBS / 100);
    end
    else
    begin
      gIBSCBS.gCBS.gRed.pRedAliq := 0;
      gIBSCBS.gCBS.gRed.pAliqEfet := 0;
    end;

    // Grupo gDif - Diferimento (SE HOUVER)
    if Result.FpDifCBS > 0 then
    begin
      gIBSCBS.gCBS.gDif.pDif := Result.FpDifCBS;
      gIBSCBS.gCBS.gDif.vDif := RoundTo(vDifCBS, -2);
      gIBSCBS.gCBS.gDevTrib.vDevTrib := RoundTo(vCBS, -2);
    end
    else
    begin
      gIBSCBS.gCBS.gDif.pDif := 0;
      gIBSCBS.gCBS.gDif.vDif := 0;
      gIBSCBS.gCBS.gDevTrib.vDevTrib := 0;
    end;

    // Calcular vIBS total (soma de UF + Municipal)
    gIBSCBS.vIBS := RoundTo(vIBSUF + vIBSMun, -2);

    // Preencher Tributação Regular
    if Result.FCSTReg <> cstNenhum then
    begin
      gIBSCBS.gTribRegular.CSTReg := Result.FCSTReg;
      gIBSCBS.gTribRegular.cClassTribReg := Result.FcClassTribReg;
      gIBSCBS.gTribRegular.pAliqEfetRegIBSUF := Result.FpAliqEfetRegIBSUF;
      gIBSCBS.gTribRegular.vTribRegIBSUF := Result.FvTribRegIBSUF;
      gIBSCBS.gTribRegular.pAliqEfetRegIBSMun := Result.FpAliqEfetRegIBSMun;
      gIBSCBS.gTribRegular.vTribRegIBSMun := Result.FvTribRegIBSMun;
      gIBSCBS.gTribRegular.pAliqEfetRegCBS := Result.FpAliqEfetRegCBS;
      gIBSCBS.gTribRegular.vTribRegCBS := Result.FvTribRegCBS;
    end;

    // Preencher Compra Governamental
    if (Result.FpAliqIBSUF > 0) or (Result.FpAliqIBSMun > 0) or (Result.FpAliqCBS > 0) then
    begin
      gIBSCBS.gTribCompraGov.pAliqIBSUF := Result.FpAliqIBSUF;
      gIBSCBS.gTribCompraGov.vTribIBSUF := Result.FvTribIBSUF;
      gIBSCBS.gTribCompraGov.pAliqIBSMun := Result.FpAliqIBSMun;
      gIBSCBS.gTribCompraGov.vTribIBSMun := Result.FvTribIBSMun;
      gIBSCBS.gTribCompraGov.pAliqCBS := Result.FpAliqCBS;
      gIBSCBS.gTribCompraGov.vTribCBS := Result.FvTribCBS;
    end;

    // Preencher Transferência de Crédito
    if (Result.FvTransfIBS > 0) or (Result.FvTransfCBS > 0) then
    begin
      gTransfCred.vIBS := Result.FvTransfIBS;
      gTransfCred.vCBS := Result.FvTransfCBS;
    end;

    // Preencher Ajuste de Competência
    // Implementar se necessário
    gAjusteCompet.competApur := Date;
    gAjusteCompet.vIBS := 0;
    gAjusteCompet.vCBS := 0;

    // Preencher Estorno de Crédito
    // Implementar se necessário
    gEstornoCred.vIBSEstCred := 0;
    gEstornoCred.vCBSEstCred := 0;

    // Preencher Crédito Presumido
    if Result.FcCredPres <> cpNenhum then
    begin
      gCredPresOper.cCredPres := Result.FcCredPres;
      gCredPresOper.vBCCredPres := Result.FvBCCredPres;
      gCredPresOper.gIBSCredPres.pCredPres := Result.FpCredPresIBS;
      gCredPresOper.gIBSCredPres.vCredPres := Result.FvCredPres;
      gCredPresOper.gIBSCredPres.vCredPresCondSus := Result.FvCredPresCondSus;
      gCredPresOper.gCBSCredPres.pCredPres := Result.FpCredPresCBS;
      gCredPresOper.gCBSCredPres.vCredPres := Result.FvCredPresCBS;
      gCredPresOper.gCBSCredPres.vCredPresCondSus := Result.FvCredPresCBSCondSus;
    end;

    // Preencher Crédito Presumido IBS ZFM
    // Implementar se necessário
    gCredPresIBSZFM.competApur := Date;
    //gCredPresIBSZFM.tpCredPresIBSZFM := tcpBensInformaticaOutros;
    gCredPresIBSZFM.vCredPresIBSZFM := 0;
  end;

  // Preencher Imposto Seletivo se aplicável
  if (AnoEmissao >= 2027) and (Result.FvIS > 0) then
  begin
    if not Assigned(Item.Imposto.ISel) then
      Item.Imposto.ISel := TgIS.Create;

    with Item.Imposto.ISel do
    begin
     // CSTIS := cstis000;
      cClassTribIS := '000001';
      vBCIS := Result.FvBCIS;
      pIS := Result.FpIS;
      pISEspec := Result.FpISEspec;
      uTrib := Result.FuTrib;
      qTrib := Result.FqTrib;
      vIS := Result.FvIS;
    end;
  end;
end;

procedure TDFeTributacaoRT.CalcularTotais;
var
  i: Integer;
  Item: TDetCollectionItem;
  TotalProd: Double;
begin
  // Validar componente ACBr
  if not Assigned(FACBr) then
    raise Exception.Create('Componente ACBrNFe não foi atribuído');

  if FACBr.NotasFiscais.Count = 0 then
    Exit;

  // Zerar totais
  FvTotalIS := 0;
  FvTotalBCIBSCBS := 0;
  FvTotalIBS := 0;
  FvTotalIBSUF := 0;
  FvTotalIBSMun := 0;
  FvTotalCBS := 0;
  TotalProd := 0;

  // Somar valores dos itens
  for i := 0 to FACBr.NotasFiscais.Items[0].NFe.Det.Count - 1 do
  begin
    Item := FACBr.NotasFiscais.Items[0].NFe.Det.Items[i];

    // Somar total dos produtos
    TotalProd := TotalProd + Item.Prod.vProd;

    // Somar IBS/CBS se existir
    if Assigned(Item.Imposto.IBSCBS) and Assigned(Item.Imposto.IBSCBS.gIBSCBS) then
    begin
      FvTotalBCIBSCBS := FvTotalBCIBSCBS + Item.Imposto.IBSCBS.gIBSCBS.vBC;
      FvTotalIBS := FvTotalIBS + Item.Imposto.IBSCBS.gIBSCBS.vIBS;

      if Assigned(Item.Imposto.IBSCBS.gIBSCBS.gIBSUF) then
        FvTotalIBSUF := FvTotalIBSUF + Item.Imposto.IBSCBS.gIBSCBS.gIBSUF.vIBSUF;

      if Assigned(Item.Imposto.IBSCBS.gIBSCBS.gIBSMun) then
        FvTotalIBSMun := FvTotalIBSMun + Item.Imposto.IBSCBS.gIBSCBS.gIBSMun.vIBSMun;

      if Assigned(Item.Imposto.IBSCBS.gIBSCBS.gCBS) then
        FvTotalCBS := FvTotalCBS + Item.Imposto.IBSCBS.gIBSCBS.gCBS.vCBS;
    end;

    // Somar IS se existir
    if Assigned(Item.Imposto.ISel) then
      FvTotalIS := FvTotalIS + Item.Imposto.ISel.vIS;
  end;

  // Calcular vNF incluindo IBS e CBS (regra a partir de 2026)
  // Por enquanto, mantemos o valor original + IBS + CBS
  if Assigned(FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot) then
    FvTotalNFTot := FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vProd +
                    FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vST +
                    FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vFrete +
                    FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vSeg +
                    FvTotalIBS + FvTotalCBS - FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vDesc;
end;

class function TDFeTributacaoRT.CalcularTotalizacao: TDFeTributacaoRT;
begin
  Result := Instance;

  // Validar componente ACBr
  if not Assigned(Result.FACBr) then
    raise Exception.Create('Componente ACBrNFe não foi atribuído');

  // Validar se há nota fiscal
  if Result.FACBr.NotasFiscais.Count = 0 then
    Exit;

  // Calcular os totais percorrendo os itens
  Result.CalcularTotais;

  // Preencher totais da Reforma Tributária
  if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.ISTot) then
    Result.FACBr.NotasFiscais.Items[0].NFe.Total.ISTot.vIS := RoundTo(Result.FvTotalIS, -2);

  if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot) then
  begin
    Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.vBCIBSCBS := RoundTo(Result.FvTotalBCIBSCBS, -2);

    if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS) then
    begin
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.vIBS := RoundTo(Result.FvTotalIBS, -2);
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.vCredPres := 0; // Implementar se necessário
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.vCredPresCondSus := 0; // Implementar se necessário

      if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSUFTot) then
      begin
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vIBSUF := RoundTo(Result.FvTotalIBSUF, -2);
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vDif := 0; // Implementar se necessário
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSUFTot.vDevTrib := 0; // Implementar se necessário
      end;

      if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSMunTot) then
      begin
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vIBSMun := RoundTo(Result.FvTotalIBSMun, -2);
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vDif := 0; // Implementar se necessário
        Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gIBS.gIBSMunTot.vDevTrib := 0; // Implementar se necessário
      end;
    end;

    if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS) then
    begin
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS.vCBS := RoundTo(Result.FvTotalCBS, -2);
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS.vDif := 0; // Implementar se necessário
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS.vDevTrib := 0; // Implementar se necessário
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS.vCredPres := 0; // Implementar se necessário
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gCBS.vCredPresCondSus := 0; // Implementar se necessário
    end;

    // Implementar outros grupos conforme necessário
    if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono) then
    begin
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vIBSMono := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vCBSMono := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vIBSMonoReten := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vCBSMonoReten := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vIBSMonoRet := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gMono.vCBSMonoRet := 0;
    end;

    if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gEstornoCred) then
    begin
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gEstornoCred.vIBSEstCred := 0;
      Result.FACBr.NotasFiscais.Items[0].NFe.Total.IBSCBSTot.gEstornoCred.vCBSEstCred := 0;
    end;
  end;

  // Atualizar valor total da NF-e
  if Assigned(Result.FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot) and (Result.FvTotalNFTot > 0) then
  begin
    // Verificar ano da emissão para decidir se inclui IBS/CBS no vNF
    // A partir de 2026, vNF deve incluir IBS e CBS
    // Por enquanto, vamos manter o valor original
    // Result.FACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot.vNF := RoundTo(Result.FvTotalNFTot, -2);
  end;
end;

initialization

finalization
  TDFeTributacaoRT.ReleaseInstance;

end.