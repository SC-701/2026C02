using Abstracciones.API;
using Abstracciones.Flujo;
using Abstracciones.Modelos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : Controller, IUsuarioController
    {
        private readonly IUsuarioFlujo _usuarioFlujo;

        public UsuarioController(IUsuarioFlujo usuarioFlujo)
        {
            _usuarioFlujo = usuarioFlujo;
        }

        [Authorize(Roles ="1")]
        [HttpPost("ObtenerInformacionUsuario")]
        public async Task<IActionResult> ObtenerUsuario([FromBody] UsuarioBase usuario)
        {
            return Ok( await _usuarioFlujo.ObtenerUsuario(usuario));
        }

        [HttpGet("ObtenerPerfilesxUsuario/{idUsuario:guid}")]
        public async Task<IActionResult> ObtenerPerfilesxUsuario([FromRoute] Guid idUsuario)
        {
            return Ok(await _usuarioFlujo.ObtenerPerfilesxUsuario(idUsuario));
        }

        [AllowAnonymous]
        [HttpPost("RegistrarUsuario")]
        public async Task<IActionResult> PostAsync([FromBody] UsuarioBase usuario)
        {
            var resultado=await _usuarioFlujo.CrearUsuario(usuario);
            return CreatedAtAction(nameof(ObtenerUsuario),null, resultado);
        }




    }
}
