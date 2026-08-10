module TestIds
  MAJOR = 1
  MINOR = 2
  BUGFIX = 4
  DEV = nil
  VERSION = [MAJOR, MINOR, BUGFIX].join(".") + (DEV ? ".pre#{DEV}" : '')
end
