# 26 — Compartilhar viagem e papéis

## Acesso
Botão Compartilhar na capa da viagem ou toque nos avatares/“+” da capa.

## Folha alta
1. Cabeçalho “Compartilhar viagem” / nome da viagem.
2. **QUEM PLANEJA JUNTO**: linhas com avatar 40 px · nome (“(você)” no seu) · papel (12 px). À direita: etiqueta roxa **Dono** para o dono; para os demais, chip **Alterar ▾** (34 px).
3. **CONVIDAR ALGUÉM**:
   - Campo “E-mail da pessoa” (48 px).
   - “Papel na viagem” — 3 cartões selecionáveis (raio 16 px; selecionado borda 2 px `#2B207F` + fundo `#F8F7FF`), com ícone em quadrado roxo 36 px e ícone lima:
     | Ícone | Papel | Descrição |
     | --- | --- | --- |
     | olho | Assistente júnior de viagem | Só visualiza. Não vê documentos nem gastos |
     | lápis | Viajante experiente (**padrão**) | Vê e edita, mas não vê documentos |
     | coroa | Viajante supremo | Vê e edita tudo |
   - Botão **Enviar convite** (50 px).
4. **VISIBILIDADE**: segmentado **Privada** | **Pública**.
   - Privada: “Só você e quem você convidou veem esta viagem.”
   - Pública: “Aparece na busca. Outras pessoas veem o roteiro, avaliam e podem clonar. Gastos e documentos continuam privados.” + caixa com o link “mayahtrip.com/v/{id}” e botão lima **Copiar** (aviso “Link copiado”).

## Folha “Papel de {nome}”
- Os 3 cartões de papel com o atual marcado; tocar troca o papel, volta à folha anterior e mostra “{nome} agora é {papel}”.
- **🗑 Remover da viagem** (contorno, texto `#D2462A`) → remove e mostra “{nome} foi removido da viagem”.
- **Voltar**.

## Regras de negócio
1. O papel é definido **ao convidar** e pode ser alterado depois.
2. E-mail inválido → aviso “Digite um e-mail válido”. Válido → a pessoa aparece na lista com o papel escolhido (nome provisório = parte do e-mail antes do @) e aviso “Convite enviado para {e-mail} como {papel}”.
3. O convidado recebe notificação (app + push) e aceita/recusa (ver `06`). Recusa notifica quem convidou.
4. Matriz de permissões em `BUSINESS.md` §4.3.
5. Só o **Dono** altera papéis e remove pessoas (no protótipo, qualquer um vê os botões). Confirmar remoção: `A DEFINIR`.
6. Viagem pública: clonar copia o roteiro; gastos e documentos nunca são públicos.

## A DEFINIR
- Convite pendente (estado “aguardando” na lista) e reenvio.
- Convidar por link além de e-mail.
- Transferir a posse (novo Dono).
