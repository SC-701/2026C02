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
        private IVehiculoFlujo _vehiculoFLujo;
        private ILogger<VehiculoController> _logger;

        public VehiculoController(IVehiculoFlujo vehiculoFLujo, ILogger<VehiculoController> logger)
        {
            _vehiculoFLujo = vehiculoFLujo;
            _logger = logger;
        }

        public Task<IActionResult> Agregar(VehiculoRequest vehiculo)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> Editar(Guid Id, VehiculoRequest vehiculo)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> Eliminar(Guid Id)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> Obtener()
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> Obtener(Guid Id)
        {
            throw new NotImplementedException();
        }
    }
}
