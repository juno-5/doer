# Doer Prometheus Alertmanager integration

Get Doer notifications from Prometheus Alertmanager!

{start_tabs}

1. {!create-an-incoming-webhook.md!}

1. {!generate-webhook-url-basic.md!}

1. In your Alertmanager config, set up a new webhook receiver, like so:

    ```
    - name: ops-doer
      webhook_configs:
        - url: "<the URL generated above>"
    ```

{end_tabs}

{!congrats.md!}

![](/static/images/integrations/alertmanager/001.png)

### Configuration options

- You can specify a field defined in your alerting rules (for labels
  and/or annotations) that will be used to group alerts with the same
  status into a single alert message in Doer by appending a `name`
  parameter to the generated URL, e.g., `&name=severity`. The default
  `name` value used in the integration is `instance`.

- You can specify a field defined in your alerting rules (for labels
  and/or annotations) that will be used in the alert message text in
  Doer by appending a `desc` parameter to the generated URL, e.g.,
  `&desc=description`. The default `desc` value used in the
  integration is `alertname`.

### Related documentation

{!webhooks-url-specification.md!}
