# MOD. image slideshow server

An image slideshow server written in [Ruby on Rails](https://rubyonrails.org). 

<img width=100% src="mod-image-server.jpg" />

## TODO:

* ~~Create Image model~~.
* ~~Create POST API for accepting images~~.
* ~~Fix Action Cable to update homepage with new images created.~~
* ~~Create slideshow on homepage of 30 most recent images.~~
* ~~Make homepage slideshow fullscreen & fit the images to it.~~

## Run the server

```$ bundle install```
```$ rake db:create```
```$ rake db:migrate```
```$ rails s -b 0.0.0.0```

Create a ```config/application.yml``` file adding:

```Ruby
app_site_title: "MOD. Draw Your Pain"
projector_width: "1920"
projector_height: "1200"
deep_dream_server: "http://localhost:5000"
image_text_overlay_font_path: "/path/to/font.ttf"
```

## Slideshow of approved images

After approving images from the `/images` screen, and tapping the `Update slideshow` button, the approved images will be saved to `/public/slideshow/`.

To get these images to display fullscreen, auto-update when new images appear from Rails, and auto-start when the computer starts, I wrote these bash scripts to run at boot:

**Generate slideshow by creating an image in a folder every 5 seconds***

```bash
#!/bin/bash
cd /home/mod/Sites/mod-image-server/public/slideshow
while true ; do for i in $(find -type f  | sort -r) ; do cp "$i" ~/slideshow.png ; echo $i ; sleep 5 ; done ; done
```

**Show image full-screen in Ubuntu using `eog`**

```bash
#!/bin/bash
eog -f ~/slideshow.png
```

**Start the Rails server on boot**

```bash
#!/bin/bash -x
source /etc/profile
cd /home/mod/Sites/mod-image-server
rails s -b 0.0.0.0
```

I then used Ubuntu’s GUI `System > Preferences > Startup Applications` to add these scripts to run on startup.

## License

Released under an [MIT License](LICENSE).

Copyright (c) 2017 [MOD.](https://mod.org.au)
