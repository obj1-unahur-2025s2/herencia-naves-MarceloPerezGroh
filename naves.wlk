class Nave {
  var velocidad = 0
  var direccionAlSol = 0
  var combustible = 0

  method acelerar(cuanto){
    velocidad = 1000.min(velocidad + cuanto)
  }

  method desacelerar(cuanto){
    velocidad = 1000.max(velocidad - cuanto)
  }
  
  method irHaciaElSol() { direccionAlSol = 10 }
  method escaparDelSol() { direccionAlSol = -10 }
  method ponerseParaleloAlSol() {direccionAlSol = 0}
  method acercarseUnPocoAlSol()  {direccionAlSol = (direccionAlSol + 1).min(10)}
  method alejarseUnPocoDelSol()  {direccionAlSol = (direccionAlSol - 1).max(-10)}
  method cargarCombustible(cuanto) {combustible += cuanto}
  method descargarCombustible(cuanto) {combustible = 0.max(combustible - cuanto)}
  method accionAdicional() // abstracto
  method prepararViaje(){
    self.cargarCombustible(3000)
    self.acelerar(5000)
    self.accionAdicional()
  }
  method estaTranquila() {
    return
    combustible >= 4000 &&
    velocidad <= 12000 && 
    self.condicionAdicional()
  }
  method condicionAdicional() //abstracto
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }
  method escapar() //abstracto
  method avisar() //abstracto

  method estaRelajado(){
    self.estaTranquila()
    self.tienePocaActividad()
  }
  method tienePocaActividad() //abstracto
}

class NaveBaliza inherits Nave{
  var colorBaliza
  var cambioBaliza
  method cambiarColorDeBaliza(colorNuevo){
    colorBaliza = colorNuevo
  }
  override method accionAdicional(){
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method condicionAdicional() {
    return colorBaliza != "rojo"
  }
  override method escapar() {
    self.irHaciaElSol()
  }
  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }
  override method tienePocaActividad() = not cambioBaliza

}

class NavePasajero inherits Nave{
  var bebida = 0
  var comida = 0
  const pasajeros = 5
  var comidaReservada = 0
  
  method cargar(cantComida, cantBebida){
    bebida = bebida + cantComida
    comida = comida + cantComida
  }
  method descargar(cantComida, cantBebida){
    bebida = 0.max(bebida + cantComida)
    comida = 0.max(comida + cantComida)
    comidaReservada = cantComida
  }
  override method accionAdicional(){
    self.cargar(4*pasajeros,6*pasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method tienePocaActividad(){
    comidaReservada >= 50
  }
}
class NaveCombate inherits Nave{
  var invisible = false
  var misilesDesplegados = false
  const mensajes = []
  method ponerseVisible(){
    invisible = false
  }
  method ponerseInvisible(){
    invisible = true
  }
  method estaInvisible() = invisible

  method desplegarMisiles() { misilesDesplegados = true}
  method replegarMisiles() { misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados 
  method emitirMensaje(mensaje){
    mensajes.add(mensaje)
  }///
  method primerMensajeEmitido() {
    if(mensajes.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajes.first() //
  }
  method ultimoMensajeEmitido() {
    if(mensajes.isEmpty()) {
      self.error("Aún no hay mensajes emitidos")
    }
    return mensajes.last() //
  }
  
  method esEscueta() {
    // Una nave de combate es _escueta_ si no emitió ningún mensaje de más de 30 caracteres.
    return mensajes.all({m=>m.length()<30})
  }

  override method accionAdicional(){
    self.ponerseVisible()
    self.emitirMensaje("Saliendo en mision")
  }

  override method condicionAdicional(){
    return !misilesDesplegados
  }
}
class NaveHospital inherits NavePasajero {
  var quirofanoEstaPreparado = true
  method prepararQuirofano() { quirofanoEstaPreparado = true}
  method quirofanoEstaPreparado() = quirofanoEstaPreparado
  override method condicionAdicional(){
    return super() && not quirofanoEstaPreparado
  }                                              
  override method recibirAmenaza(){
    super()
    self.prepararQuirofano()
  }
}

class NaveSigilosa inherits NaveCombate {
  override method condicionAdicional(){
    return  not self.estaInvisible()
  }
  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}


///