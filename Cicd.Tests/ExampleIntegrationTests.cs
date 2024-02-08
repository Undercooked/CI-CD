using Cicd.App;
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using Microsoft.AspNetCore.Mvc.Testing;

namespace Cicd.Tests;

sealed public class ExampleIntegrationTests : WebApplicationFactory<Program>, IAsyncLifetime
{
    readonly IContainer _exampleContainer;

    public ExampleIntegrationTests()
    {
        _exampleContainer = new ContainerBuilder()
            .WithImage("alpine:latest")
            .Build();
    }

    public async Task InitializeAsync()
    {
        await _exampleContainer.StartAsync();
    }

    Task IAsyncLifetime.DisposeAsync()
    {
        return Task.CompletedTask;
    }

    [Fact]
    public void ExampleIntegrationTest()
    {
        // This test always passes if the docker container is able to successfully start.
    }
}
