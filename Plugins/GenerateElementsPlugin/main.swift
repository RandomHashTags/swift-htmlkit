
import PackagePlugin

@main
struct GenerateElementsPlugin : BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return []
    }
}