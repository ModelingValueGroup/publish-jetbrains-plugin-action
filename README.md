# upload-jetbrains-plugin-action
upload a plugin to the JetBrains marketplace

## Example Usage

When gave can be taken from pom.xml:
```yaml
      - name: "Upload as package"
        uses: ModelingValueGroup/upload-jetbrains-plugin-action@master
        with:
          file    : "my-plugin.zip"
          hubToken: "${{ secrets.HUB_TOKEN }}"
          pluginId: "123456789"
          channel : "eap"
```

### ```file```
This should always be a zip file. All details like version and name are taken from the zip.

### ```hubToken```
You can create a token on https://hub.jetbrains.com.

### ```pluginId```
This is a number identifying your plugin.
If you do not have a pluginId yet you should probably upload a first version manually on https://plugins.jetbrains.com/plugin/add

### ```channel```
For details see https://plugins.jetbrains.com/plugin/add.

The default for ```channel``` is taken from the branch of the repo:
- **master** ➡︎ **stable**
- **develop** ➡︎ **eap**
- other ➡︎ skip publishing
