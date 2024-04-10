# Systemd Service Template

## Requirements
- service template for systemd started at boot
- depending of another service
- 3 restart attempts if start fails
- setting a environment variable
- setting a work directory.

## Template

```ini
[Unit]
Description=My Service
Requires=other_service.service
After=network-online.target other_service.service

[Service]
Type=simple
Restart=on-failure
RestartCount=3
Environment="MYVAR=value"
WorkingDirectory=%h/my_working_directory
ExecStartPre=-/usr/local/bin/prepare_environment
ExecStart=/path/to/your_binary %%i
ExecReload=/path/to/reload_script
ExecStopPost=-/usr/local/bin/cleanup_environment
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=myservice
User=username
Group=groupname

[Install]
WantedBy=multi-user.target
```

## Details

Let's go through the different sections:

1. `[Unit]`: This section describes metadata about your service, such as its name and dependencies (in this case, it requires "other\_service.service" to be running before starting).
2. `[Service]`: In this section, you define the type of your service (simple in our example), set up restart behavior (on-failure with three attempts), configure environment variables, working directory, and specify the ExecStart command for starting the service along with any pre/post commands as needed.
3. `[Install]`: This section sets up the wanted target runlevels for your service to be started automatically at boot time (in this example, it's set to "multi-user.target").

## Deployment
To use this file, save it in the appropriate location under `/etc/systemd/system`, reload Systemd configuration with `sudo systemctl daemon-reload` and then enable and start your service using:
```bash
sudo systemctl enable my_service.service
sudo systemctl start my_service.service
```
This example assumes that you have another service named "other\_service" already configured, and the binary for this service is located at `/path/to/your_binary`. The prepare\_environment and cleanup\_environment scripts are optional and should be used to set up or clean up any necessary environment variables before starting or stopping your service. 

# Add useful extensions to .bashrc

This script, `add_extensions_to_bashrc.sh`, enhances the user's `.bashrc` file with additional functionalities and aliases for the bash environment. Here's a concise summary of its actions:

1. **Set Path to `.bashrc`**: It defines a `BASHRC` variable pointing to the user's `.bashrc` file, which contains bash configuration settings loaded at the start of a bash session.

2. **Function `add_if_not_exists`**: This function checks whether a specific line exists in a file and appends it if not found. It uses `grep` with options to search for a whole line match quietly, treating the pattern as fixed text.

3. **Adding Alias `fz`**: Adds an alias named `fz` that invokes `fzf` with a preview option using `batcat` to display files with syntax highlighting and line numbers, enhancing file exploration.

4. **Custom `cd` Function**: Adds a custom `cd` function if not already present, which overwrites the built-in `cd` to append the new directory path to a `.cd_history` file, creating a navigable history of visited directories.

5. **Function `cf`**: If not existing, it adds a `cf` function that allows navigating previously visited directories using `fzf` to select from `.cd_history`, facilitating easy directory switching.

6. **Confirmation Message**: Outputs a message indicating that modifications have been made to the `.bashrc` file.

The script significantly improves command line interaction by providing quick navigation tools and visually enriched file browsing capabilities.
