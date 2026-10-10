# Revisi Profesional PPT Hari 2 dan Hari 3

Deck Hari 2 dan Hari 3 dibangun ulang agar lebih visual, lebih advanced, dan
lebih mudah dipakai saat mengajar. Keduanya tetap mengikuti urutan dan batas
scope buku pendamping.

## Perubahan Hari 2

- Clean boundaries: View, controller, repository, remote/local data source.
- Constructor injection, test seam, DTO/domain mapping, dan explicit state.
- REST API client Flutter dengan model bertipe dan failure mapping.
- Backend hosted diposisikan sebagai prasyarat; mock Python menjadi fallback.
- Environment melalui `API_BASE_URL`, typed failure, cache policy, session,
  idempotency, observability, dan fault-injection matrix.
- Tiga lab dengan Definition of Done serta checklist integrasi Flutter.

## Perubahan Hari 3

- Adapter untuk plugin foto, state machine, lifecycle, dan ownership file.
- Test portfolio: unit, state/repository, widget, contract, dan smoke test.
- Quality gate, performance experiment yang repeatable, dan DevTools evidence.
- Release identity, signing chain, APK/AAB verification, risk-based smoke test,
  release notes, rollback, dan handover.

## Format

- 16:9, 39 slide per deck.
- Tema navy–cyan–gold mengikuti cover buku.
- Diagram, flow, decision matrix, code panel, dan section divider native PPT.
- Presenter notes tersedia di setiap slide.
- File root `Hari_2_Flutter_Professional.pptx` dan
  `Hari_3_Flutter_Professional.pptx` identik dengan delivery copy di folder ini.

Deck dapat dibuat ulang dengan:

```sh
python3 tools/build_professional_decks.py
```

