VPCI <- function(src, volume, shortTerm, longTerm) {
  vpc <- VWMA(src, volume, longTerm) - SMA(src, longTerm)
  vpr <- VWMA(src, volume, shortTerm)/SMA(src, shortTerm)
  vm  <- SMA(volume, shortTerm)/SMA(volume, longTerm)
  vpci <- vpc*vpr*vm
  return(vpci)
}

BBandsBreach <- function(bb) {
  upBreach <- ifelse(bb[,'vpci'] >= bb[,'up'], 1, 0)
  dnBreach <- ifelse(bb[,'vpci'] <= bb[,'dn'], -1, 0)
  return(upBreach+dnBreach)
}

VPCIBBands <- function(src, volume, shortTerm, longTerm) {
  vpci <- VPCI(src,volume, shortTerm, longTerm)
  bBands <- BBands(vpci, n = longTerm, sd = 2.5)

  bb <- cbind(bBands, vpci)
  breach <- BBandsBreach(bb)

  return(cbind(bb, breach))
}