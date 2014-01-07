require 'fileutils'

module Sinatra
  module Videoman
    module Tasks
      def self.install_views_task views_dir
        File.open(views_dir + '/edit.erb', 'w') do |file|
          file.write <<-VIEW
            <%= partial :video, :video => @video %>
          VIEW
        end

        File.open(views_dir + '/show.erb', 'w') do |file|
          file.write <<-VIEW
            <%= partial :video, :video => @video %>
          VIEW
        end

        File.open(views_dir + '/upload.erb', 'w') do |file|
          file.write <<-VIEW
            <script type='text/javascript'>
              function addFields(){
                var container = document.getElementById("video_files");
                container.appendChild(document.createTextNode("Video: "));
                var input = document.createElement("input");
                input.type = "file";
                input.name = "video_files[]";
                container.appendChild(input);
                container.appendChild(document.createElement("br"));
              }
            </script>
            <%= flash[:error] %>
            <%= flash[:notice] %>
            <form id="video_form" enctype="multipart/form-data" method="post" action="/videos/upload">
              <fieldset id="video_files">
                <legend>Video files</legend>
                Video: <input type="file" name="video_files[]" required /></br>
              </fieldset>
              <table border="0">
                <tr>
                  <td><label for="title">Title:</label></td>
                  <td><input id="title" type="text" name="video[title]" placeholder="Video title" required /></td>
                </tr>
                <tr>
                  <td><label for="description">Description:</label></td>
                  <td><input id="description" type="text" name="video[description]" placeholder="Video description" required /></td>
                </tr>
                <tr>
                  <td><label for="thumbnail">Thumbnail:</label></td>
                  <td><input id="thumbnail" type="file" name="video[thumbnail]" required /></td>
                </tr>
                <tr>
                  <td><input type="submit" value="Upload" /></td>
                  <td><input type="button" value="Add file" onclick="addFields()" /></td>
                </tr>
              </table>
            </form>
          VIEW
        end

        File.open(views_dir + '/show.erb', 'w') do |file|
          file.write <<-VIEW
            <h3><%= video.title %></h3>
            <video width="320" height="240" controls>
              <% video.video_files.each do |source| %>
                <source src=<%= source.file.url %> type=<%= source.content_type %> />
              <% end %>
                Your browser does not support the video tag.
            </video>
            <div id="description">
              <%= video.description %>
            </div>
          VIEW
        end
      end
    end
  end
end
