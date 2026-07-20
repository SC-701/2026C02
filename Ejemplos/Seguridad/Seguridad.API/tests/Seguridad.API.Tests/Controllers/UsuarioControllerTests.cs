using Abstracciones.Flujo;
using Abstracciones.Modelos;
using API.Controllers;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using NSubstitute;
using Xunit;

namespace Seguridad.API.Tests.Controllers;

public class UsuarioControllerTests
{
    [Fact]
    public async Task ObtenerPerfilesxUsuario_CuandoRecibeIdUsuario_RetornaOkConPerfiles()
    {
        // Arrange
        var usuarioFlujo = Substitute.For<IUsuarioFlujo>();
        var idUsuario = Guid.NewGuid();
        var perfilesEsperados = new List<Perfil>
        {
            new() { Id = 1, Nombre = "Administrador" }
        };

        usuarioFlujo.ObtenerPerfilesxUsuario(idUsuario).Returns(perfilesEsperados);
        var controller = new UsuarioController(usuarioFlujo);

        // Act
        var resultado = await controller.ObtenerPerfilesxUsuario(idUsuario);

        // Assert
        resultado.Should().BeOfType<OkObjectResult>()
            .Which.Value.Should().BeEquivalentTo(perfilesEsperados);
        await usuarioFlujo.Received(1).ObtenerPerfilesxUsuario(idUsuario);
    }
}
