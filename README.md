# S3-Amysynth in the browser

The firmware of [S3-Amysynth](https://github.com/rt-rtos/S3-Amysynth), an
ESP32-S3 synthesizer with a step sequencer, running in a web page: the
sequencer, the OLED user interface and the AMY synthesis engine, compiled to
WebAssembly from the same sources as the device firmware.

Open it at <https://rt-rtos.github.io/amysynth-web/>.

## What runs here

The page runs the device's application code and audio engine. It is not an
emulation of the chip: there is no USB audio, no Bluetooth MIDI, and the
render timing of the board is not reproduced. Audio is rendered in fixed
point at 48 kHz, as on the device.

Everything runs in your browser. Nothing is sent anywhere, and the page makes
no network requests after it has loaded. Projects you save are kept in the
browser's own storage on your device.

## Using it

- **Power on** starts the audio. Browsers only start audio from a click or a
  tap, so the device is silent until then.
- The panel below the screen lists the inputs: keyboard, mouse, touch and a
  gamepad all drive the six buttons and the encoder.
- What each input does on each screen is the device's own control scheme,
  shown on the page and kept in `controls.md`.
- The firmware version the page was built from is shown in the page.

## Running it locally

The files have to be served over HTTP; a browser will not load the
WebAssembly module from a page opened straight from disk. Any static file
server works:

    python3 -m http.server

then open <http://localhost:8000/>.

## Contents

| File | Role |
|---|---|
| `index.html`, `common.js`, `common.css`, `wasm.js` | the page |
| `hostsim.js`, `hostsim.wasm` | the compiled firmware and engine, with Emscripten's loader |
| `hostsim.data` | AMY's drum sample banks |
| `controls.md` | the device's control scheme |
| `notices.txt` | third-party notices for everything compiled in |

Built with Emscripten by
[amysynth-wasm](https://github.com/rt-rtos/amysynth-wasm), which has the
firmware as a submodule and compiles its sources unchanged. What that repo
adds in place of the device (stand-ins for ESP-IDF, FreeRTOS and the board's
drivers, and the program that runs instead of the firmware's `main.c`) is
listed file by file in its
[SHIMS.md](https://github.com/rt-rtos/amysynth-wasm/blob/main/SHIMS.md).
The version shown in the page is the firmware commit it was built from.

## Licence

The project's own code is under the MIT License (`LICENSE`). The notices
for the compiled-in third-party code and data are in `notices.txt`.
