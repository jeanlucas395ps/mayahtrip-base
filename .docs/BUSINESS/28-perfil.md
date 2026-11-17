# 28 — Perfil

## Layout (rolagem; 120 px de folga na base)
1. **Capa** 200 px (foto) com degradê escuro no topo. Topo (52 px): etiqueta branca 90% “📍 {cidade, país}” (30 px) e botão vidro “⋯” → menu do perfil.
2. **Foto do usuário** — **circular 104 px**, borda 5 px na cor do fundo, sombra `0 8px 24px rgba(21,18,46,.18)`, sobrepondo a capa em 52 px. Selo lima 32 px com câmera no canto inferior direito. Toque → escolher nova foto (ver `34`).
3. À direita da foto: **✏️ Editar perfil** (contorno 40 px) + **Compartilhar** (ícone 40 px, aviso “Link do perfil copiado”).
4. Nome editorial **36 px**; “@usuário · Viajante curioso” (13 px); bio (13 px, line-height 1,5); link (roxo, ícone de link).
5. Contadores (14 px): **seguidores** e **seguindo** (toque → `30-social.md`), **posts** (sem toque).
6. **Jornada até aqui** (cartão, padding 16 px):
   - Título h2 + link “↗ Divulgar” (aviso “Cartão da jornada copiado para compartilhar”).
   - Grade 3 × 2 (espaço 8 px). Cada indicador: borda `#E5E3EC`, raio 18 px, padding 12 px; **ícone padronizado** em quadrado 32 px (raio 11) **`#2B207F` com ícone lima 16 px** e sombra roxa; número h2 20 px à direita; rótulo 12 px/700 `#5E5A73` abaixo. Ao passar o dedo/mouse, o ícone gira −6° e cresce 6% (mola).
     | Ícone | Indicador | Regra | Toque |
     | --- | --- | --- | --- |
     | globo | Continentes | Continentes com país visitado | Onde já estive |
     | bandeira | Países | Países visitados | Onde já estive |
     | prédio | Cidades | Cidades de viagens passadas | Onde já estive |
     | pin | Lugares | Paradas visitadas (`A DEFINIR` regra) | — |
     | rota | Km viajados | `A DEFINIR` regra | — |
     | carteira | Viagens | Viagens na carteira + passadas | — |
   - **Mini mapa-múndi** (fundo `#F0EEF6`, raio 18 px) com países visitados/planejados (ver `32`) e etiqueta “X% do mundo · N planejados”. Toque → Onde já estive.
7. **Abas** (segmentado): **Publicações · Mídia · Menções**.
   - Publicações: **até 3** cartões; se houver mais, botão “Ver mais N publicações ›” → `29`.
   - Mídia: grade 3 colunas (proporção 4:5, espaço 4 px, raio 18 px no conjunto) com **até 9** itens; vídeos com duração. Mais de 9 → “Ver todas as N mídias ›”.
   - Menções: **até 5**; mais → “Ver todas as N menções ›”.
8. **Plano** (bloco `#2B207F`, raio 22 px): coroa em quadrado lima 44 px · nome do plano vigente · uma linha de apoio · botão lima. Free: “Conheça os benefícios do plano PRO” e **Ver PRO**. PRO: “Seu plano está ativo” e **Gerenciar plano**. Os dois botões abrem o site de planos no navegador do aparelho (`WEB/01`). O app não cobra.
9. **Configurações** (cartão):
   - **Aparência** com segmentado Automático · Claro · Noturno (ver `33`).
   - Lugares onde já estive → `32` · Privacidade e bloqueios → `31` · Preferências de viagem (`A DEFINIR`) · Meus documentos (`A DEFINIR`) · **Idioma e moeda** (mostra “Minha localização” ou “Personalizado”) → `35` · Notificações → `06`.
   - **Sair** (vermelho `#D2462A`) → encerra a sessão e volta ao login.

## Cartão de publicação
- Cabeçalho: sua foto 34 px · nome · “{lugar} · {cidade} · {mês ano}” · estrelas (nota) · botão “⋯” (34 px) → menu da publicação (`29`).
- Mídia 220 px; vídeo mostra duração; várias mídias mostram “1/N”; arquivada mostra “Arquivado”.
- Legenda 13 px; rodapé 12 px: **♡ curtidas** (toque → aba Curtidas de `10`), **💬 comentários** (toque → aba Comentários de `10`), “🔖 Salvo por N”.

## Menu do perfil (⋯)
Compartilhar perfil · Copiar link do perfil · Privacidade e bloqueios.

## Regras
- Convidado não acessa o Perfil (convite para criar conta).
- Removidos do perfil: botões “Meu mapa”, selo “Explorador”, selo verificado.
