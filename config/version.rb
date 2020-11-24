module TestIds
  MAJOR = 1
  MINOR = 2
  BUGFIX = 0
  DEV = nil
  VERSION = [MAJOR, MINOR, BUGFIX].join(".") + (DEV ? ".pre#{DEV}" : '')
end
