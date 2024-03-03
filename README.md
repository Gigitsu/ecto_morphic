# EctoMorphic
EctoMorphic is an Elixir library that enhances Ecto with support for polymorphic and dynamic embedded schemas. It allows you to define embedded schemas dynamically at runtime, providing flexibility in your Ecto models.

## Features
 - Define polymorphic and dynamic embedded schemas in Ecto models.
 - Support for embedding different schemas based on runtime conditions.
 - Simplified syntax for defining and working with dynamic embedded schemas.

## Installation
To use `EctoMorphic` in your Elixir project, simply add it as a dependency in your `mix.exs` file:

```elixir
def deps do
  [
    {:ecto_morphic, "~> 0.1.0"}
  ]
end
```

Then, run `mix deps.get` to fetch the dependency.

## Usage
To use EctoMorphic, first, ensure that you have Ecto set up in your project.

## Contributing
Contributions to EctoMorphic are welcome! To contribute, please fork this repository, make your changes, and submit a pull request.

## License
EctoMorphic is released under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
