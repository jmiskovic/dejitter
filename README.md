# dejitter

A simple and fast filter that removes jitter from input signal. It uses exponential smoothing, with its smoothing factor being continuously adapted to input signal. If the input signal is changing slowly it will be more heavily filtered, and fast-changing signal will be tracked faster with less lag. 

The filter can be applied to object coordinates that contain jitter/noise. Stationary object will be tracked percisely, while fast object will be tracked with tiny amount of lag. Two parameters (cutoff frequency and beta) need to be tuned to get the desired results.

```lua
cutoff, beta = 1e-3, 4e-4
filter = require('dejitter')(cutoff, beta)

-- feed the next sample into the filter
output = filter(time, input)
-- output will be numerically close to input, but smoothed out over time
```

`cutoff` parameter controls filtering frequency. Low value will cut more jitter from input, but also introduces lag. `beta` parameter affects speed of adaptivity. Higher values will lower the lag more agressively. 

The algorithm is [1€ Filter](http://cristal.univ-lille.fr/~casiez/1euro/) as elaborated in [article](https://jaantollander.com/post/noise-filtering-using-one-euro-filter/). There is also an alternative Lua implementation [here](https://github.com/stevelavietes/pico8carts/blob/master/one_euro_filter.p8).

The `main.lua` contains a simple demo to be used with [LÖVE](https://love2d.org/) interpreter. Input signal is sine wave with superimposed noise. The cutoff and beta are controlled by mouse position. For demo the whole signal is re-filtered on each frame, while in practice each frame would process just a single input sample.
