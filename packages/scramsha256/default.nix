{ writers, ... }:
writers.writePython3Bin "scramsha256" { flakeIgnore = [ "E501" ]; } (
  builtins.readFile ./scramsha256.py
)
