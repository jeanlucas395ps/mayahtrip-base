# Protótipo interativo — MayahTrip

Versão fechada do protótipo (16 nov 2026). É a **referência visual e de comportamento** para o app Flutter, junto com `../DESIGN.md` e `../BUSINESS/`.

## Como abrir
Sirva a pasta por HTTP (o mapa-múndi é carregado via `fetch`, então abrir o arquivo direto pode falhar):

```bash
cd .docs/prototype
python3 -m http.server 8765
# abra http://localhost:8765
```

Frame de referência: 390 × 844. Em telas ≤ 520 px de largura o protótipo ocupa a tela inteira.

## Conteúdo
| Caminho | O que é |
| --- | --- |
| `index.html` | App inteiro (HTML, CSS e JS num arquivo só). Tokens de cor em `:root` e `#app.dark` |
| `img/` | Fotos dos destinos, avatar padrão e avatar da Maya |
| `flags/` | Bandeiras circulares (circle-flags, licença MIT) |
| `screens/` | **Telas de referência** em claro e noturno (133 capturas cada), nomeadas pela funcionalidade. Índice em `screens/README.md` |
| `world.json` | Mapa-múndi pré-projetado (Equal Earth), gerado de world-atlas/Natural Earth |

Dependência externa: fontes do Google Fonts (Plus Jakarta Sans e Instrument Serif).

## Regras
- O protótipo é **referência**, não código de produção.
- Se o protótipo, `DESIGN.md` ou `BUSINESS/` divergirem, registre a divergência e decida qual vale antes de implementar.
- Dados são simulados (código de verificação: `1234`).
