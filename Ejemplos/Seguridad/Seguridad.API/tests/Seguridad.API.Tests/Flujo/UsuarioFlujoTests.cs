using Abstracciones.DA;
using Abstracciones.Modelos;
using FluentAssertions;
using NSubstitute;
using Flujo;
using Xunit;

namespace Seguridad.API.Tests.Flujo;

public class UsuarioFlujoTests
{
    [Fact]
    public async Task ObtenerPerfilesxUsuario_CuandoRecibeIdUsuario_DelegaEnElAccesoDatos()
    {
        // Arrange
        var usuarioDA = Substitute.For<IUsuarioDA>();
        var idUsuario = Guid.NewGuid();
        var perfilesEsperados = new List<Perfil>
        {
            new() { Id = 1, Nombre = "Administrador" }
        };

        usuarioDA.ObtenerPerfilesxUsuario(idUsuario).Returns(perfilesEsperados);
        var flujo = new UsuarioFlujo(usuarioDA);

        // Act
        var resultado = await flujo.ObtenerPerfilesxUsuario(idUsuario);

        // Assert
        resultado.Should().BeEquivalentTo(perfilesEsperados);
        await usuarioDA.Received(1).ObtenerPerfilesxUsuario(idUsuario);
    }
}
