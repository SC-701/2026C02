# 🛡️ Cómo funciona la seguridad — JWT, Hash y Middleware explicados

> **Para quién es este documento:** Estudiantes que quieren entender el **por qué** y el
> **cómo** detrás del código de seguridad implementado en la Semana 06.
>
> Este documento es conceptual. Para ver los pasos de implementación, revisa:
> 👉 `Explicaciones/guia-migracion-seguridad.md`

---

## 🗺️ El flujo completo de un vistazo

Antes de entrar en detalle, aquí está la imagen completa de cómo se comunican los componentes:

```mermaid
sequenceDiagram
    actor U as 👤 Usuario
    participant W as 🌐 WEB
    participant VA as 🚗 API Vehículos
    participant SA as 🔐 API Seguridad

    U->>W: Llena correo y contraseña
    W->>W: SHA256(password) → hash
    W->>SA: POST /login { correo, hash }
    SA->>SA: Valida usuario y contraseña en BD
    SA-->>W: { AccessToken: "eyJ...", ok: true }
    W->>W: Lee claims del JWT
    W->>W: Guarda JWT en cookie cifrada
    W-->>U: Redirige a /Vehiculos

    Note over U,W: Usuario ya está autenticado

    U->>W: Navega a /Vehiculos
    W->>W: Lee JWT desde la cookie
    W->>VA: GET /api/vehiculo<br/>Authorization: Bearer {JWT}
    VA->>VA: Valida firma del JWT
    VA->>VA: Verifica rol = "1"
    VA-->>W: Lista de vehículos
    W-->>U: Muestra los vehículos
```

---

## 🔑 Concepto 1 — Hashing de Contraseñas (SHA256)

### ¿Por qué no guardar la contraseña directamente en la base de datos?

Esta es la pregunta más importante. La respuesta corta: **la base de datos siempre puede ser robada**. La diferencia entre un sistema seguro y uno inseguro está en qué tan útil es ese robo para el atacante.

---

#### ❌ Escenario inseguro — contraseñas en texto claro

```mermaid
sequenceDiagram
    actor U as 👤 Usuario
    participant W as 🌐 WEB
    participant DB as 🗄️ Base de Datos

    U->>W: POST /registro { password: "MiPass123" }
    W->>DB: INSERT usuario (password = "MiPass123")
    Note over DB: password = "MiPass123" ← guardado tal cual

    Note over DB: 💥 Atacante roba la BD
    DB-->>U: El atacante ahora tiene "MiPass123"
    Note over U: 🚨 Si el usuario usa esa contraseña<br/>en Gmail, banco, redes sociales...<br/>todas sus cuentas están comprometidas
```

Con contraseñas en texto claro:
- Un empleado deshonesto puede ver tus contraseñas
- Si hackean la BD, obtienen **todas las contraseñas de todos los usuarios**
- El usuario que repite contraseñas en varios servicios pierde **todas** sus cuentas

---

#### ✅ Escenario seguro — contraseñas hasheadas

```mermaid
sequenceDiagram
    actor U as 👤 Usuario
    participant W as 🌐 WEB
    participant DB as 🗄️ Base de Datos

    U->>W: POST /registro { password: "MiPass123" }
    W->>W: hash = SHA256("MiPass123")<br/>= "a3f9b1c72d8e45f9..."
    W->>DB: INSERT usuario (passwordHash = "a3f9b1c72d8e45f9...")
    Note over DB: passwordHash = "a3f9b1c72d8e45f9..."<br/>✅ la contraseña original NO existe aquí

    Note over DB: 💥 Atacante roba la BD
    DB-->>U: El atacante tiene "a3f9b1c72d8e45f9..."
    Note over U: ❓ ¿Cómo convierte "a3f9b1..."<br/>de vuelta a "MiPass123"?<br/>👉 NO PUEDE. El hash es irreversible.
```

Con hashing el atacante obtiene una cadena de texto inútil que **no puede revertir**.

---

### ¿Qué pasa durante el Login?

El truco está en que no necesitamos "deshacer" el hash. Simplemente **repetimos la operación** y comparamos:

```mermaid
flowchart TD
    A([👤 Usuario escribe su contraseña]) --> B["Contraseña: 'MiPass123'"]
    B --> C["SHA256('MiPass123')<br/>= 'a3f9b1...'"]
    C --> D[Enviar hash al servidor]

    D --> E{"¿Coincide con<br/>el hash guardado<br/>en la BD?"}

    F[(🗄️ BD<br/>passwordHash = 'a3f9b1...')] --> E

    E -- "✅ Sí, son iguales" --> G[Login exitoso<br/>→ Generar JWT]
    E -- "❌ No coinciden" --> H[Login rechazado<br/>→ Error 401]

    style G fill:#22c55e,color:#fff
    style H fill:#ef4444,color:#fff
    style C fill:#3b82f6,color:#fff
```

> La contraseña **nunca se almacena** en el servidor. Solo se almacena su hash irreversible.

---

### Propiedades clave del hash SHA256

```mermaid
graph LR
    A["SHA256<br/>(función matemática)"]

    A --> B["🔁 Determinista<br/>Mismo input<br/>= mismo output<br/>siempre"]
    A --> C["🚫 Irreversible<br/>'a3f9b1...'<br/>no se puede<br/>convertir de vuelta"]
    A --> D["🌊 Efecto avalancha<br/>Cambiar 1 letra<br/>cambia TODO<br/>el resultado"]
    A --> E["📏 Longitud fija<br/>Cualquier texto<br/>→ siempre 64<br/>caracteres hex"]

    style A fill:#6366f1,color:#fff
    style B fill:#0ea5e9,color:#fff
    style C fill:#0ea5e9,color:#fff
    style D fill:#0ea5e9,color:#fff
    style E fill:#0ea5e9,color:#fff
```

**Ejemplos del efecto avalancha:**
```
SHA256("MiContraseña123") = "a3f9b1c72d...8e45f9"
SHA256("MiContraseña124") = "b7d2a8c91e...3a12b4"  ← completamente distinto
SHA256("micontraseña123") = "f4c7e2a81b...9d23c5"  ← solo cambia mayúscula
```

---

### ¿Por qué SHA256 y no cifrado (AES, RSA)?

Esta distinción es fundamental para entender la decisión de diseño:

```mermaid
graph TD
    subgraph CIFRADO["🔐 Cifrado (AES / RSA)"]
        C1["Texto original"]
        C2["Texto cifrado"]
        C3["Texto original recuperado"]
        C1 -->|"cifrar con clave"| C2
        C2 -->|"descifrar con clave"| C3
        direction TB
    end

    subgraph HASH["🔒 Hash (SHA256)"]
        H1["Texto original"]
        H2["Hash"]
        H3["❌ Imposible recuperar<br/>el texto original"]
        H1 -->|"hash"| H2
        H2 -->|"???"| H3
        direction TB
    end

    CIFRADO -->|"Si alguien roba<br/>la clave de cifrado..."| X["😱 Descifra TODAS<br/>las contraseñas"]
    HASH    -->|"Si alguien roba<br/>los hashes..."| Y["😌 No puede hacer nada.<br/>No existe clave que robar."]

    style X fill:#ef4444,color:#fff
    style Y fill:#22c55e,color:#fff
```

El cifrado es reversible con una clave. Si esa clave se compromete, todas las contraseñas se exponen. Un hash no tiene clave — es simplemente irreversible por diseño matemático.

---

### El código en C#

```csharp
// En Reglas/Autenticacion.cs

public static byte[] GenerarHash(string contrasenia)
{
    using (SHA256 shaHash = SHA256.Create())
    {
        // Convierte el texto a bytes UTF-8, luego aplica SHA256
        byte[] bytes = shaHash.ComputeHash(Encoding.UTF8.GetBytes(contrasenia));
        return bytes;  // Array de 32 bytes (256 bits)
    }
}

public static string ObtenerHash(byte[] hash)
{
    // Convierte el array de bytes a texto hexadecimal legible
    // Ej: [163, 249, 177, ...] → "a3f9b1..."
    StringBuilder builder = new StringBuilder();
    for (int i = 0; i < hash.Length; i++)
        builder.Append(hash[i].ToString("x2"));  // "x2" = hex con 2 dígitos
    return builder.ToString();
}
```

### ¿Cómo se usa en el Login?

```csharp
// En Login.cshtml.cs — OnPost()

// 1. El usuario escribió: "MiContraseña123"
var Hash = Autenticacion.GenerarHash(loginInfo.Password);
// Hash es ahora: byte[] { 163, 249, 177, ... }

loginInfo.PasswordHash = Autenticacion.ObtenerHash(Hash);
// PasswordHash es ahora: "a3f9b1c72d...8e45f9"

// 2. Enviamos el hash al API, NUNCA la contraseña original
await client.PostAsJsonAsync(endpoint, new LoginBase {
    CorreoElectronico = loginInfo.CorreoElectronico,
    PasswordHash      = loginInfo.PasswordHash,  // ✅ solo el hash
    // Password no se envía                       // ✅ contraseña NO incluida
});
```

En la base de datos también se guarda el hash, no la contraseña. Al hacer login, el API recalcula el hash y lo compara con lo que está guardado.

---

## 🎫 Concepto 2 — JWT (JSON Web Token)

### ¿Qué es un JWT?

Un JWT es un **token de seguridad** que el servidor crea y firma. Es como un carnet de identidad digital:
- El servidor lo emite después de verificar las credenciales
- El cliente lo presenta en cada petición
- El servidor puede verificar su autenticidad sin consultar una base de datos

### Estructura de un JWT

Un JWT tiene exactamente **3 partes** separadas por puntos:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikp1YW4gUGVyZXoiLCJyb2wiOiIxIiwiaWF0IjoxNzA5NDAwMDAwfQ
.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

```mermaid
graph LR
    subgraph H["🔵 HEADER — Base64"]
        H1["Algoritmo: HMACSHA256<br/>Tipo: JWT"]
    end
    subgraph P["🟡 PAYLOAD — Base64"]
        P1["sub: guid-usuario<br/>name: Juan Perez<br/>email: juan@ufide.ac.cr<br/>rol: 1<br/>iat: emitido<br/>exp: +2 horas"]
    end
    subgraph S["🔴 SIGNATURE — Base64"]
        S1["HMACSHA256(<br/>  header + payload,<br/>  clave-secreta<br/>)"]
    end

    H -->|" . "| P
    P -->|" . "| S

    style H fill:#3b82f6,color:#fff
    style P fill:#f59e0b,color:#fff
    style S fill:#ef4444,color:#fff
```

> 🔓 `HEADER` y `PAYLOAD` son solo **Base64** — cualquiera puede leerlos.
> 🔒 La `SIGNATURE` garantiza que nadie los modificó. Solo el servidor con la clave secreta puede crear firmas válidas.

> 🔓 El Header y el Payload son **Base64 — no cifrado**. Cualquiera puede leerlos.
> 🔒 La Signature garantiza que nadie los modificó. Solo el servidor con la clave secreta puede crear firmas válidas.

### Los Claims — la información dentro del token

Los **claims** son los datos que viajan dentro del JWT. En nuestro sistema:

| Claim | Tipo | Valor ejemplo | Uso |
|-------|------|--------------|-----|
| `name` | `ClaimTypes.Name` | `"juan"` | Mostrar nombre en la UI |
| `nameid` | `ClaimTypes.NameIdentifier` | `"guid-del-usuario"` | Identificador único |
| `email` | `ClaimTypes.Email` | `"juan@ufide.ac.cr"` | Correo institucional |
| `role` | `ClaimTypes.Role` | `"1"` | Control de acceso |
| `Token` | custom | `"eyJ..."` | El JWT completo guardado en la cookie |

### ¿Cómo se genera el JWT en el servidor?

Esto ocurre dentro del **API de Seguridad** (`Ejemplos/Seguridad/Seguridad.API`):

```csharp
// Simplificación del proceso de generación del token:

var tokenHandler = new JwtSecurityTokenHandler();
var key = Encoding.UTF8.GetBytes("Textoparagenerarelotkenjwtdelapi");

var tokenDescriptor = new SecurityTokenDescriptor
{
    Subject = new ClaimsIdentity(new[]
    {
        new Claim(ClaimTypes.Name,           usuario.NombreUsuario),
        new Claim(ClaimTypes.NameIdentifier, usuario.Id.ToString()),
        new Claim(ClaimTypes.Email,          usuario.CorreoElectronico),
        new Claim(ClaimTypes.Role,           usuario.IdRol.ToString()),
    }),
    Expires    = DateTime.UtcNow.AddMinutes(120),       // Vence en 2 horas
    Issuer     = "localhost",                            // Quién lo emitió
    Audience   = "localhost",                            // Para quién es
    SigningCredentials = new SigningCredentials(
        new SymmetricSecurityKey(key),
        SecurityAlgorithms.HmacSha256Signature
    )
};

SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
string tokenString  = tokenHandler.WriteToken(token);  // "eyJ..."
```

### ¿Cómo se valida el JWT en la API de Vehículos?

Cuando llega una petición con `Authorization: Bearer eyJ...`, ASP.NET Core automáticamente:

```mermaid
flowchart TD
    A(["📨 Llega petición con<br/>Authorization: Bearer eyJ..."])
    A --> B["1. Extrae el token del header"]
    B --> C["2. Decodifica Base64"]
    C --> D{"3. ¿Firma válida?<br/>(clave secreta de appsettings)"}
    D -- "❌ No" --> Z1["401 Unauthorized"]
    D -- "✅ Sí" --> E{"4. ¿No ha vencido?<br/>(claim exp)"}
    E -- "❌ Vencido" --> Z2["401 Unauthorized"]
    E -- "✅ Vigente" --> F{"5. ¿Issuer y<br/>Audience coinciden?"}
    F -- "❌ No" --> Z3["401 Unauthorized"]
    F -- "✅ Sí" --> G["6. Llena HttpContext.User<br/>con los claims del token"]
    G --> H(["✅ Continúa al siguiente<br/>middleware / controller"])

    style Z1 fill:#ef4444,color:#fff
    style Z2 fill:#ef4444,color:#fff
    style Z3 fill:#ef4444,color:#fff
    style H fill:#22c55e,color:#fff
```

Esto lo configura este bloque en `Program.cs`:

```csharp
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer           = true,   // ¿El Issuer coincide?
            ValidateAudience         = true,   // ¿El Audience coincide?
            ValidateLifetime         = true,   // ¿No venció?
            ValidateIssuerSigningKey = true,   // ¿La firma es válida?
            ValidIssuer              = jwtIssuer,
            ValidAudience            = jwtAudience,
            IssuerSigningKey         = new SymmetricSecurityKey(
                                           Encoding.UTF8.GetBytes(jwtKey))
        };
    });
```

---

## 🍪 Concepto 3 — Cookie de Autenticación en la WEB

### ¿Por qué la WEB usa cookies y no JWT directamente?

La WEB Razor Pages es una aplicación web tradicional. Los navegadores saben manejar cookies automáticamente — las envían en cada request sin que el código deba hacer nada especial.

```mermaid
graph TD
    Cookie(["🍪 Cookie ASP.NET Core<br/>(cifrada y firmada automáticamente)"])

    Cookie --> N["ClaimTypes.Name<br/>= 'juan'"]
    Cookie --> NI["ClaimTypes.NameIdentifier<br/>= 'guid-usuario'"]
    Cookie --> E["ClaimTypes.Email<br/>= 'juan@ufide.ac.cr'"]
    Cookie --> T["Claim: Token<br/>= 'eyJhbGciOiJ...'<br/>← el JWT completo"]

    style Cookie fill:#6366f1,color:#fff
    style T fill:#f59e0b,color:#000
```

> ASP.NET Core **cifra y firma** estos datos automáticamente. El usuario del navegador no puede leer ni modificar el contenido de la cookie.

### El flujo de login en la WEB paso a paso

```mermaid
flowchart TD
    A(["👤 Usuario envía correo + contraseña"])
    A --> B["1️⃣ Generar hash<br/>SHA256('MiPass123') = 'a3f9b1...'"] 
    B --> C["2️⃣ POST al API Seguridad<br/>{ NombreUsuario, CorreoElectronico, PasswordHash }"]
    C --> D{"3️⃣ ¿ValidacionExitosa?"}
    D -- "❌ false" --> E(["Error: credenciales inválidas"])
    D -- "✅ true" --> F["Recibe AccessToken: 'eyJ...'"]
    F --> G["4️⃣ Decodifica JWT<br/>leerToken(AccessToken)<br/>→ lee claims sin verificar firma"]
    G --> H["5️⃣ Crea ClaimsPrincipal<br/>con los claims del JWT"]
    H --> I["HttpContext.SignInAsync(principal)<br/>→ ASP.NET Core crea la cookie cifrada"]
    I --> J(["6️⃣ Redirige a la página solicitada"])

    style E fill:#ef4444,color:#fff
    style J fill:#22c55e,color:#fff
```

### ¿Cómo acceden las páginas al token JWT guardado en la cookie?

```csharp
// En cualquier página .cshtml.cs protegida:

var cliente = new HttpClient();
cliente.DefaultRequestHeaders.Authorization =
    new System.Net.Http.Headers.AuthenticationHeaderValue(
        "Bearer",
        HttpContext.User.Claims             // Lee los claims de la cookie
            .Where(c => c.Type == "Token") // Busca el claim llamado "Token"
            .FirstOrDefault().Value        // Obtiene el JWT string
    );
```

El flujo es:

```mermaid
flowchart LR
    A(["🍪 Cookie"]) --> B["HttpContext.User.Claims"]
    B --> C["Claim tipo 'Token'"]
    C --> D["JWT string<br/>'eyJ...'"] 
    D --> E(["Authorization:<br/>Bearer {JWT}"])

    style A fill:#6366f1,color:#fff
    style E fill:#22c55e,color:#fff
```

---

## 🧩 Concepto 4 — Middleware: `AutorizacionClaims()`

### ¿Qué es un Middleware?

El middleware en ASP.NET Core es código que se ejecuta **para toda petición HTTP**, en el orden en que fue registrado. Es como una cadena de filtros:

```mermaid
flowchart TD
    REQ(["📨 Petición HTTP"])
    REQ --> A

    A["🔒 UseHttpsRedirection<br/>Redirige HTTP → HTTPS"]
    A --> B

    B["🌐 UseCors<br/>Aplica política de orígenes cruzados"]
    B --> C

    C["🔑 UseAuthentication<br/>Lee token/cookie<br/>Llena HttpContext.User"]
    C --> D

    D["📋 AutorizacionClaims<br/>Paquete custom — consulta BD<br/>de seguridad y agrega claims de rol"]
    D --> E

    E["🛡️ UseAuthorization<br/>Verifica atributo [Authorize]<br/>y permisos del usuario"]
    E --> F

    F(["✅ Controller / Razor Page<br/>Llega a tu código"])

    style REQ fill:#6366f1,color:#fff
    style C fill:#3b82f6,color:#fff
    style D fill:#f59e0b,color:#000
    style E fill:#8b5cf6,color:#fff
    style F fill:#22c55e,color:#fff
```

### ¿Qué hace específicamente `AutorizacionClaims()`?

Este middleware es el paquete `Autorizacion.Middleware`. Su trabajo es consultar la base de datos de seguridad para enriquecer los claims del usuario con información adicional (como el nombre del rol, permisos específicos, etc.).

```csharp
// Se agrega como Extension Method en Program.cs:
app.AutorizacionClaims();

// Internamente hace algo similar a esto:
public static void AutorizacionClaims(this IApplicationBuilder app)
{
    app.Use(async (context, next) =>
    {
        if (context.User.Identity.IsAuthenticated)
        {
            // Consulta la BD de seguridad con el userId del token
            // y agrega claims de roles/permisos al usuario actual
            var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            // ... consulta y agrega claims ...
        }
        await next(context);  // Continúa con el siguiente middleware
    });
}
```

### ¿Por qué el orden del middleware importa?

```csharp
// ✅ CORRECTO
app.UseAuthentication();  // Primero: identifica quién es el usuario
app.AutorizacionClaims(); // Segundo: agrega info de la BD (necesita saber quién es)
app.UseAuthorization();   // Tercero: verifica si puede acceder (necesita la info completa)

// ❌ INCORRECTO — AutorizacionClaims no sabe quién es el usuario aún
app.AutorizacionClaims();
app.UseAuthentication();
app.UseAuthorization();
```

---

## 🔒 Concepto 5 — Autorización basada en Roles

### `[Authorize]` vs `[Authorize(Roles = "1")]`

```csharp
// Solo verifica que el usuario esté autenticado (tiene sesión)
[Authorize]
public class VehiculoController : ControllerBase { }

// Además verifica que el usuario tiene el rol con Id = 1
[Authorize(Roles = "1")]
public async Task<IActionResult> Agregar([FromBody] VehiculoRequest v) { }
```

### ¿Cómo funciona la verificación de roles?

```mermaid
flowchart TD
    A(["📨 Petición llega a<br/>[Authorize(Roles = '1')]"])
    A --> B["ASP.NET Core busca<br/>ClaimTypes.Role en HttpContext.User"]
    B --> C{"¿Existe el<br/>claim 'role'?"}
    C -- "❌ No existe" --> D(["401 Unauthorized<br/>No estás autenticado"])
    C -- "✅ Existe" --> E{"¿El valor del<br/>claim role == '1'?"}
    E -- "❌ Valor distinto" --> F(["403 Forbidden<br/>Autenticado pero sin permiso"])
    E -- "✅ Coincide" --> G(["Acceso concedido<br/>→ ejecuta el método del controller"])

    style D fill:#ef4444,color:#fff
    style F fill:#f97316,color:#fff
    style G fill:#22c55e,color:#fff
```

### Diferencia entre 401 y 403

| Código | Nombre | Significa |
|--------|--------|-----------|
| `401` | Unauthorized | No estás autenticado (sin token o token inválido) |
| `403` | Forbidden | Estás autenticado pero no tienes permiso para este recurso |

---

## 📦 Concepto 6 — Los Paquetes NuGet del Curso

El curso usa paquetes custom publicados en GitHub Packages:

| Paquete | Responsabilidad |
|---------|----------------|
| `Autorizacion.Abstracciones` | Interfaces: `IAutorizacionFlujo`, `ISeguridadDA` |
| `Autorizacion.DA` | Acceso a datos: consultas a la BD de seguridad |
| `Autorizacion.Flujo` | Lógica: valida credenciales, genera tokens |
| `Autorizacion.Middleware` | Extension method `app.AutorizacionClaims()` |

```mermaid
graph LR
    M["📦 Autorizacion.Middleware<br/>app.AutorizacionClaims()"]
    F["📦 Autorizacion.Flujo<br/>Valida credenciales<br/>Genera tokens"]
    DA["📦 Autorizacion.DA<br/>Acceso a datos<br/>Consultas BD seguridad"]
    AB["📦 Autorizacion.Abstracciones<br/>Interfaces:<br/>IAutorizacionFlujo<br/>ISeguridadDA"]

    M -->|depende de| F
    F -->|depende de| DA
    DA -->|depende de| AB

    style M fill:#6366f1,color:#fff
    style F fill:#3b82f6,color:#fff
    style DA fill:#0ea5e9,color:#fff
    style AB fill:#22c55e,color:#fff
```

Los cuatro paquetes se instalan al mismo tiempo con la misma versión `2.0.6`.

---

## 🏗️ Concepto 7 — Arquitectura completa del sistema de seguridad

```mermaid
graph TB
    subgraph WEB["🌐 Vehiculos.WEB — Cookie Auth"]
        WL["Login Page<br/>↓ SHA256(password)<br/>↓ Llama API Seguridad<br/>↓ Guarda JWT en cookie"]
        WP["Páginas protegidas<br/>[Authorize]<br/>→ Lee JWT de cookie<br/>→ Pone en Authorization: Bearer"]
    end

    subgraph VAPI["🚗 Vehiculo.API — JWT Bearer Auth"]
        VC["VehiculoController<br/>MarcaController<br/>ModeloController<br/><br/>[Authorize(Roles = '1')]"]
        VVAL["Valida:<br/>✓ Firma del JWT<br/>✓ Fecha de expiración<br/>✓ Issuer y Audience<br/>✓ Rol del usuario"]
    end

    subgraph SAPI["🔐 API de Seguridad"]
        SL["Valida hash en BD<br/>Genera JWT firmado<br/>Retorna AccessToken"]
    end

    subgraph BD["🗄️ BD Seguridad (Azure)"]
        BT["Tablas:<br/>• Usuarios (passwordHash)<br/>• Roles<br/>• UsuarioRoles"]
    end

    WL -->|"POST /login<br/>{ correo, passwordHash }"| SL
    SL -->|"{ AccessToken: 'eyJ...' }"| WL
    WP -->|"GET /api/vehiculo<br/>Authorization: Bearer {JWT}"| VC
    VC --> VVAL
    VVAL -->|"consulta roles<br/>del usuario"| SL
    SL <-->|"valida + consulta"| BT

    style WEB fill:#1e40af,color:#fff
    style VAPI fill:#065f46,color:#fff
    style SAPI fill:#7c3aed,color:#fff
    style BD fill:#92400e,color:#fff
```

---

## 💡 Resumen — cinco ideas para recordar

| Concepto | En una línea |
|----------|-------------|
| **Hash SHA256** | Transforma la contraseña en texto irreversible — nunca se envía la contraseña real |
| **JWT** | Carnet digital firmado por el servidor — cualquiera puede leer los datos, nadie puede falsificarlos |
| **Claims** | Los datos del usuario que viajan dentro del JWT — nombre, email, rol |
| **Cookie** | La WEB guarda el JWT cifrado en una cookie para no pedirlo en cada página |
| **Middleware** | Filtro que se ejecuta en cada petición — verifica autenticidad antes de llegar al controller |

---

## 🔗 Referencias del código fuente en este repositorio

| Concepto | Archivo |
|----------|---------|
| Generación del hash | `Semana 06.../Vehiculos.WEB/Reglas/Autenticacion.cs` |
| Configuración JWT en la API | `Semana 06.../Vehiculo.API/API/Program.cs` |
| Cookie auth en la WEB | `Semana 06.../Vehiculos.WEB/Web/Program.cs` |
| Flujo del login | `Semana 06.../Vehiculos.WEB/Web/Pages/Cuenta/Login.cshtml.cs` |
| Autorización en controllers | `Semana 06.../Vehiculo.API/API/Controllers/VehiculoController.cs` |
| Modelos de seguridad | `Semana 06.../Vehiculos.WEB/Abstracciones/Modelos/Seguridad/` |

---

*Documento creado para SC701 — Semana 06 | Referencia: `CodigoBase/Semana 06-API y WEB con Seguridad`*
