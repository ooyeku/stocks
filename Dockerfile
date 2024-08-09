# Copyright 2024 olayeku
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use the official Julia image as a base
FROM julia:1.10

# Set the working directory
WORKDIR /app

# Copy the Project.toml and Manifest.toml files
COPY Project.toml /app/
COPY Manifest.toml /app/

# Install the dependencies
RUN julia -e 'using Pkg;Pkg.instantiate()'


# Copy the rest of the application code
COPY . /app

# Set the default command to run the main.jl script
CMD ["julia"]