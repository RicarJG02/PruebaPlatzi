# PruebaPlatzi

## Guía del Proyecto

### Entorno de Desarrollo

- **IDE:** Xcode - El proyecto fue realizado en Xcode Version 14.2 (14C18) ✅
- **Lenguaje:** Swift ✅
- **Arquitectura:** MVVM ✅
- **Framework:** SwiftUI ✅
- **API:** Pexels para uso de videos // Creo que era preferencia ✅

---

### Primera Pantalla: Lista de Objetos

- Mostrar una lista de objetos con detalles esenciales como título, imagen miniatura, subtítulo, duración, etc. ✅
- Consumir datos de una API usando `async` y `await`. ✅

---

### Segunda Pantalla: Vista Detallada

- Al tocar en un elemento de la lista, navegar a una pantalla de detalles. ✅
- Mostrar toda la información relevante del objeto. ✅
- Incluir un reproductor de video o audio para el objeto seleccionado. ✅

---

### Modo Offline

- Implementar persistencia de datos para el uso sin conexión. Puedes usar Realm, Core Data o SQLite. ✅ Con Preferencia Realm
- **Nota:** No usar User Defaults para la persistencia de datos. ✅

---

### Puntos Extra

- Implementar funcionalidad para detectar cambios en la conectividad de red y mostrar al usuario cuando esté desconectado. ✅
- Uso del framework Combine para la gestión de eventos y estados. ✅❌
- Incluir Unit Tests y/o UI tests para garantizar que las funcionalidades clave de la aplicación funcionan como se espera. ❌
