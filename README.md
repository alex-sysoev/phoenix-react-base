# Phoenix React Project Base

Simple project base on [Phoenix](http://www.phoenixframework.org/) backend & [React](https://facebook.github.io/react/) - [Redux](redux.js.org). It can be used as a starter for your projects that require registration, authentication, authorization & channels features.

## Dependencies

```
Elixir 1.4.0
Phoenix 1.2.1
Node 7.4.0
Npm 4.0.5
Webpack 2.2.1
PostgreSQL 9.3
```

## Installation

In order to install and run this project ensure that you have all dependencies installed. Clone the project, go to it's folder. Make sure that you have all ENV variables set or replace it with your values in configuration files and run following commands:

```bash
mix deps.get
mix ecto.setup
npm install
```
Now you would be able to launch server running ```mix phoenix.server``` command and access to ```localhost:4000``` in your browser.

## Testing

### Backend
For testing application backend the ExUnit framework. To execute these tests just run ```mix test```.

### Frontend
Not implemented yet :(

## Contribution

Any desire to make this base interesting, more serious & practical and any pull request are welcome.
