# jevhouse

A container image of [jev-at-home](https://github.com/Jibril-Frej/jev-at-home),
a CPU server of Jev-compatible typed decisions (`POST /v1/systemone`), built at
the commit `JEVHOME_REF` in the `Dockerfile`. The image holds the binary only;
a model directory from [huggingface.co/jevhome](https://huggingface.co/jevhome)
is mounted at run time.

```shell
mkdir -p models/jevhome-B-int8
for f in calibration_u.json config.json decision_config.json model.onnx tokenizer.json tokenizer_config.json; do
  curl -sSfL -o models/jevhome-B-int8/$f https://huggingface.co/jevhome/jevhome-B-int8/resolve/main/$f
done
docker run --rm -p 8009:8009 -v "$PWD/models:/models:ro" ghcr.io/mikluko/jevhouse:X.Y.Z
```

The default command serves `/models/jevhome-B-int8` on `0.0.0.0:8009` with
the server's default thread count; pass `serve <model dir> [--threads N]
[--port P] [--host H]` to change it.

Every push to `main` is tagged `main-<sha>-<unix time>`; a `vX.Y.Z` tag is
published as `X.Y.Z`. `linux/amd64` only.

## Helm

Each `vX.Y.Z` tag also publishes the chart in `charts/jevhouse` at the same
version, without the `v`.

```shell
helm install jevhouse oci://ghcr.io/mikluko/charts/jevhouse --version X.Y.Z
```

No value is required. `model.name` is the model the server loads: an init
container downloads its files from the Hugging Face repository of that name
under `model.repository` into an `emptyDir`, on every pod start. Every value is
described in [`values.yaml`](charts/jevhouse/values.yaml).

The image's own files are MIT. The jev-at-home code is MIT; the model
weights are CC BY-NC 4.0 and are not in the image.
