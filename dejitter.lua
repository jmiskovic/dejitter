-- "1€ filter" is fast and elegant method for removing jitter from real-time signal
-- the algorithm preforms adaptive low-pass exponential smoothing of input signal
-- created by G. Casiez, N. Roussel, and D. Vogel
-- this implementation based on Jaan Tollander de Balsch's version
-- https://jaantollander.com/post/noise-filtering-using-one-euro-filter

local function smoothing_factor(t_e, cutoff)
  local r = 2 * math.pi * cutoff * t_e
  return r / (r + 1)
end

local function exponential_smoothing(a, x, x_prev)
  return a * x + (1 - a) * x_prev
end

-- cutoff parameter controls filtering frequency, low value filters harder but introduces lag
-- beta parameter affects speed of adaptivity, higher values will lower the lag
local function create_filter(cutoff, beta)
  local self = {}
  self.cutoff     = cutoff or 1.0
  self.beta       = beta or 0.0
  self.d_cutoff   = 1.0
  self.dx0        = 0.0
  self.x_prev     = 0.0
  self.dx_prev    = 0.0
  self.t_prev     = 0.0

  return function (t, x)
    local t_e = t - self.t_prev
    -- the filtered derivative of the signal
    local a_d = smoothing_factor(t_e, self.d_cutoff)
    local dx = (x - self.x_prev) / t_e
    local dx_hat = exponential_smoothing(a_d, dx, self.dx_prev)
    -- the filtered signal
    cutoff = self.cutoff + self.beta * math.abs(dx_hat)
    local a = smoothing_factor(t_e, cutoff)
    local x_hat = exponential_smoothing(a, x, self.x_prev)
    -- memorize the previous values
    self.x_prev = x_hat
    self.dx_prev = dx_hat
    self.t_prev = t
    return x_hat
  end
end

return create_filter
