using Abstracciones.Interfaces.DA;
using Abstracciones.Modelos;
using Microsoft.Data.SqlClient;


namespace DA
{
    public class VehiculoDA : IVehiculoDA
    {
        private IRepositorioDapper _repositorioDapper;
        private SqlConnection _sqlConnection;

        public VehiculoDA(IRepositorioDapper repositorioDapper)
        {
            _repositorioDapper = repositorioDapper;
            _sqlConnection=_repositorioDapper.ObtenerRepositorio();
        }

        public Task<Guid> Agregar(VehiculoRequest vehiculo)
        {
            throw new NotImplementedException();
        }

        public Task<Guid> Editar(Guid Id, VehiculoRequest vehiculo)
        {
            throw new NotImplementedException();
        }

        public Task<Guid> Eliminar(Guid Id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<VehiculoResponse>> Obtener()
        {
            throw new NotImplementedException();
        }

        public Task<VehiculoResponse> Obtener(Guid Id)
        {
            throw new NotImplementedException();
        }
    }
}
