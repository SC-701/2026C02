using Abstracciones.Interfaces.API;
using Abstracciones.Interfaces.Flujo;
using Abstracciones.Modelos;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VehiculoController : ControllerBase, IVehiculoController
    {
        private IVehiculoFlujo _vehiculoFlujo;
        private ILogger<VehiculoController> _logger;

        public VehiculoController(IVehiculoFlujo vehiculoFLujo, ILogger<VehiculoController> logger)
        {
            _vehiculoFlujo = vehiculoFLujo;
            _logger = logger;
        }
        [HttpPost]
        public async Task<IActionResult> Agregar(VehiculoRequest vehiculo)
        {
            var resultado = await _vehiculoFlujo.Agregar(vehiculo);
            return CreatedAtAction(nameof(Obtener), new { Id = resultado }, null);
        }
        [HttpPut("{Id}")]
        public async Task<IActionResult> Editar([FromRoute] Guid Id, [FromBody] VehiculoRequest vehiculo)
        {
            var resultado = await _vehiculoFlujo.Editar(Id, vehiculo);
            return Ok(resultado);
        }
        [HttpDelete("{Id}")]
        public async Task<IActionResult> Eliminar(Guid Id)
        {
            var resultado = await _vehiculoFlujo.Eliminar(Id);
            return NoContent();
        }
        [HttpGet]
        
        public async Task<IActionResult> Obtener()
        {
            var resultado = await _vehiculoFlujo.Obtener();
            if (!resultado.Any())
                return NoContent();
            return Ok(resultado);
        }
        [HttpGet("ObtenerPorId/{Id}")]        
        public async Task<IActionResult> Obtener(Guid Id)
        {
            var resultado = await _vehiculoFlujo.Obtener(Id);
            return Ok(resultado);
        }
    }
}
