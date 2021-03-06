class Page::Layouts::Sports < Layout

  def schema
    {
      'slideshow' => {
        'label' => 'Slideshow',
        'type' => 'object',
        'required' => true,
        'properties' => {
          'articles' => {
            'label' => 'Articles',
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          },
          'pages' => {
            'label' => 'Page IDs',
            'type' => 'array',
            'items' => page_schema,
          }
        }
      },
      'twitter_widget' => {
        'label' => 'Twitter Widget ID',
        'type' => 'string',
        'required' => true,
      },
      'poll' => {
        'label' => 'Poll',
        'extends' => poll_schema,
      },
      'multimedia' => {
        'label' => 'Embedded Multimedia',
        'type' => 'array',
        'required' => true,
        'items' => {
          'type' => 'string',
          'format' => 'multiline',
        }
      },
      'bottom_articles' => {
        'label' => 'Bottom Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'nav_links' => {
        'label' => 'Navigation links',
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'name' => {
              'label' => 'Label',
              'type' => 'string',
            },
            'href' => {
              'label' => 'Path',
              'type' => 'string',
            }
          }
        }
      }
    }
  end

end
