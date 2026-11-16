# 29 — Gerenciar publicações, mídias e menções

Tela única com título conforme a origem: **Minhas publicações**, **Minhas mídias** ou **Menções** (topo: voltar · título h3).

## Minhas publicações
- Filtros: **Todas · N** (não arquivadas) · **Mais curtidas** (ordenadas por curtidas) · **Arquivadas · N**.
- Lista de cartões de publicação (mesmo cartão do Perfil). Vazio em Arquivadas: “Nada por aqui” / “Posts arquivados aparecem nesta aba.”
- **Menu ⋯ da publicação**:
  1. ✏️ **Editar legenda** → folha com área de texto (4 linhas) + **Salvar** (aviso “Legenda atualizada”; vazio mantém a anterior).
  2. 📋 **Copiar link** (aviso “Link copiado”).
  3. 🔖 **Arquivar** / ↩ **Desarquivar** (avisos “Publicação arquivada” / “Publicação restaurada”). Arquivada sai do perfil e do feed.
  4. 🗑 **Excluir publicação** (vermelho) → confirmação “Excluir publicação?” / “Curtidas e comentários também serão apagados.” com **Cancelar** e **Excluir** (`#D2462A`). Após excluir: aviso “Publicação excluída” + **Desfazer**.

## Minhas mídias
- “N itens” + chip **Selecionar** (vira **Cancelar**).
- Grade 3 colunas 4:5. Em seleção: caixa redonda 24 px no canto; item selecionado encolhe para 90% com cantos 12 px.
- Barra fixa (20 px da base): **Salvar** (contorno, baixa no aparelho) e **🗑 Excluir N** (vermelho), desativados sem seleção.
- Excluir → confirmação “Excluir N mídia(s)?” / “Isso não pode ser desfeito.” → aviso “Mídias excluídas”.

## Menções
- “N menções” + link **Marcar como vistas**.
- Linha: avatar 38 px · “**@pessoa** {ação} **{alvo}**” · tempo · botão ✕ (remover marcação; aviso “Marcação removida” + **Desfazer**).
- Ações possíveis: marcou você em, clonou seu roteiro, mencionou você em, respondeu sua dica, salvou seu post, respondeu seu comentário.
- Cartão “👥 Quem pode te marcar — Pessoas que você segue” (configuração `A DEFINIR`).

## Regras
- Excluir mídia remove de quais publicações? `A DEFINIR`.
- Menções geram notificação (app + push).
